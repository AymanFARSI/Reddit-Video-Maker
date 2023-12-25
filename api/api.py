import json
import os
from random import randrange
from typing import Tuple

import moviepy.editor as editor
import moviepy.video as video
import praw
from flask import Flask, abort, request
from playwright.sync_api import ViewportSize, sync_playwright
from pydub import AudioSegment

from tiktok import TikTok

# backgroundVideos = glob.glob("assets/background/video/*.mp4")
# backgroundMusic = glob.glob("assets/background/music/*.mp3")

TEXT_BYTE_LIMIT = 290
WIDTH = 1080
HEIGHT = 1920

app = Flask(__name__)


def create_directories():
    if not os.path.exists("assets"):
        os.makedirs("assets")
    if not os.path.exists("assets/images"):
        os.makedirs("assets/images")
    if not os.path.exists("assets/audio"):
        os.makedirs("assets/audio")
    # if not os.path.exists("assets/background"):
    #     os.makedirs("assets/background")
    if not os.path.exists("output"):
        os.makedirs("output")


def deleteFiles(directory):
    filelist = [f for f in os.listdir(directory) if not f.endswith(".gitignore")]
    for f in filelist:
        if f != ".gitkeep":
            os.remove(os.path.join(directory, f))


def deleteTemporaryFiles():
    deleteFiles("assets/images")
    deleteFiles("assets/audio")


def clear_cookie_by_name(context, cookie_cleared_name):
    cookies = context.cookies()
    filtered_cookies = [
        cookie for cookie in cookies if cookie["name"] != cookie_cleared_name
    ]
    context.clear_cookies()
    context.add_cookies(filtered_cookies)


def split_string(string: str, chunk_size: int) -> list[str]:
    words = string.split()
    result = []
    current_chunk = ""
    for word in words:
        if (
            len(current_chunk) + len(word) + 1 <= chunk_size
        ):  # Check if adding the word exceeds the chunk size
            current_chunk += " " + word
        else:
            if current_chunk:  # Append the current chunk if not empty
                result.append(current_chunk.strip())
            current_chunk = word
    if current_chunk:  # Append the last chunk if not empty
        result.append(current_chunk.strip())
    return result


def createTitleImage(url, username, password):
    with sync_playwright() as p:
        browser = p.firefox.launch(headless=False)
        context = browser.new_context(
            locale="en",
            viewport=ViewportSize(width=1920, height=1080),
            color_scheme="dark",
        )

        # cookie_file = open("assets/cookies/cookie-dark-mode.json", encoding="utf-8")
        # cookies = json.load(cookie_file)
        # cookie_file.close()
        # context.add_cookies(cookies)  # load preference cookies
        page = context.new_page()
        page.goto("https://www.reddit.com/login", timeout=0)
        page.set_viewport_size(ViewportSize(width=1920, height=1080))
        page.wait_for_load_state()

        page.locator('[name="username"]').fill(username)
        page.locator('[name="password"]').fill(password)
        page.locator("button[class$='m-full-width']").click()
        page.wait_for_timeout(5000)

        login_error_div = page.locator(".AnimatedForm__errorMessage").first
        if login_error_div.is_visible():
            login_error_message = login_error_div.inner_text()
            if login_error_message.strip() == "":
                # The div element is empty, no error
                pass
            else:
                # The div contains an error message
                print("Your reddit credentials are incorrect!")
                exit()
        else:
            pass

        page.wait_for_load_state()
        # Handle the redesign
        # Check if the redesign optout cookie is set
        if page.locator("#redesign-beta-optin-btn").is_visible():
            # Clear the redesign optout cookie
            clear_cookie_by_name(context, "redesign_optout")
            # Reload the page for the redesign to take effect
            page.reload()

        page.goto(url, timeout=0)
        # remove NSFW warning
        if page.locator('[data-testid="content-gate"]').is_visible():
            page.locator('[data-testid="content-gate"] button').click()
            page.locator('button:has-text("CLICK TO SEE NSFW")').click()
        try:
            page.locator('[data-test-id="post-content"]').screenshot(
                path="assets/images/title.png",
            )
        except Exception as e:
            print(e)


def createAudioWithImage():
    questionAudio = editor.AudioFileClip("assets/audio/tiktok_title.mp3")
    questionVideo = editor.ColorClip(
        (WIDTH, HEIGHT),
        (0, 0, 0, 0),
        duration=questionAudio.duration,
    )
    questionVideo = questionVideo.set_audio(questionAudio)
    # questionImage = editor.ImageClip("assets/images/title.png").set_duration(
    #     questionAudio.duration
    # )
    # questionImage = questionImage.crop(
    #     x1=0,
    #     y1=0,
    #     width=questionImage.size[0],
    #     height=75,
    # )
    # zoom_factor = 0.8
    # new_width = int(questionImage.size[0] * zoom_factor)
    # new_height = int(questionImage.size[1] * zoom_factor)
    # questionImage = questionImage.resize(width=new_width, height=new_height)
    # questionImage = questionImage.resize(width=new_width, height=90)
    # questionVideo = questionImage.set_audio(questionAudio)
    contentAudio = editor.AudioFileClip("assets/audio/tiktok_content.mp3")
    contentVideo = editor.ColorClip(
        (WIDTH, HEIGHT),
        (0, 0, 0, 0),
        duration=contentAudio.duration,
    )
    contentVideo = contentVideo.set_audio(contentAudio)
    return editor.concatenate_videoclips(
        [questionVideo, contentVideo],
        method="compose",
    )


def get_start_and_end_times(video_length: int, length_of_clip: int) -> Tuple[int, int]:
    initialValue = 180
    # Issue #1649 - Ensures that will be a valid interval in the video
    while int(length_of_clip) <= int(video_length + initialValue):
        if initialValue == initialValue // 2:
            raise Exception("Your background is too short for this video length")
        else:
            initialValue //= 2  # Divides the initial value by 2 until reach 0
    random_time = randrange(initialValue, int(length_of_clip) - int(video_length))
    return random_time, random_time + video_length


def addBackgroundVideo(videoClip, background):
    # select random background video
    backgroundClip = editor.VideoFileClip(background).without_audio()
    start_time_audio, end_time_audio = get_start_and_end_times(
        videoClip.duration, backgroundClip.duration
    )
    backgroundClip = backgroundClip.subclip(start_time_audio, end_time_audio)
    backgroundClip = video.fx.all.loop(backgroundClip, duration=videoClip.duration)
    return editor.CompositeVideoClip(
        [backgroundClip, videoClip.set_position("center").set_opacity(0.9)]
    )


# def addBackgroundMusic(videoClip, duration):
#     print("adding background music")
#     # select random background music
#     music = editor.AudioFileClip(random.choice(backgroundMusic))
#     # adapt duration to video (by looping or cutting)
#     music = audio.fx.all.audio_loop(music, duration=duration)
#     music = audio.fx.all.volumex(music, 0.2)
#     joinedAudio = editor.CompositeAudioClip([videoClip.audio, music])
#     videoClip.audio = joinedAudio
#     return videoClip


def editVideo(finalVideo):
    editedVideo = finalVideo.resize(width=1920, height=1080)
    return editedVideo


@app.route("/scrape", methods=["POST"])
def scrape():
    client_id = request.form.get("client_id")
    client_secret = request.form.get("client_secret")
    subreddit = request.form.get("subreddit")
    sort = request.form.get("sort")
    limit = int(request.form.get("limit"))

    if not client_id or not client_secret or not subreddit or not sort or not limit:
        abort(400, "Bad request")

    if sort not in ["hot", "new", "top", "rising"]:
        abort(500, "Sort must be one of hot, new, top, rising")
    else:
        user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0"

        reddit = praw.Reddit(
            client_id=client_id,
            client_secret=client_secret,
            user_agent=user_agent,
        )

        subreddit = reddit.subreddit(subreddit)
        run = 1

        if sort == "hot":
            posts = subreddit.hot(limit=limit)
        elif sort == "new":
            posts = subreddit.new(limit=limit)
        elif sort == "top":
            posts = subreddit.top(limit=limit)
        elif sort == "rising":
            posts = subreddit.rising(limit=limit)

        posts_dist = {
            "title": [],
            "url": [],
            "content": [],
        }

        for post in posts:
            posts_dist["title"].append(post.title)
            posts_dist["url"].append(post.url)
            posts_dist["content"].append(post.selftext)

            run += 1

        posts_dist["count"] = run
        posts_json = json.dumps(posts_dist)
        return posts_json


@app.route("/fetch", methods=["POST"])
def fetch():
    client_id = request.form.get("client_id")
    client_secret = request.form.get("client_secret")
    url = request.form.get("url")

    if not client_id or not client_secret or not url:
        abort(400, "Bad request")

    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0"

    reddit = praw.Reddit(
        client_id=client_id,
        client_secret=client_secret,
        user_agent=user_agent,
    )

    submission = reddit.submission(url=url)

    posts_dist = {
        "title": submission.title,
        "url": submission.url,
        "content": submission.selftext,
    }

    posts_json = json.dumps(posts_dist)
    return posts_json


@app.route("/tts", methods=["POST"])
def tts():
    title = request.form.get("title")
    text = request.form.get("text")
    voice = request.form.get("voice")
    session_id = request.form.get("session_id")

    if not title or not text or not voice:
        abort(400, "Bad request")
    try:
        create_directories()
        deleteTemporaryFiles()
        output_dir = "assets/audio"

        tiktok = TikTok(session_id)
        tiktok.run(title, f"{output_dir}/tiktok_title.mp3", voice)
        if len(text) < TEXT_BYTE_LIMIT:
            tiktok.run(text, f"{output_dir}/tiktok_content.mp3", voice)
        else:
            count = 0
            for chunk in split_string(text, TEXT_BYTE_LIMIT):
                tiktok.run(chunk, f"{output_dir}/tiktok_content_{count}.mp3", voice)
                count += 1

            for i in range(count):
                if i == 0:
                    combined = AudioSegment.from_mp3(
                        f"{output_dir}/tiktok_content_{i}.mp3",
                    )
                else:
                    combined += AudioSegment.from_mp3(
                        f"{output_dir}/tiktok_content_{i}.mp3",
                    )

            combined.export(f"{output_dir}/tiktok_content.mp3", format="mp3")

            for i in range(count):
                os.remove(f"{output_dir}/tiktok_content_{i}.mp3")

        output_dir = os.path.abspath(output_dir)
        return_dict = {
            "path": output_dir,
            "title": f"{output_dir}/tiktok_title.mp3",
            "text": f"{output_dir}/tiktok_content.mp3",
        }
        return_json = json.dumps(return_dict)
        return return_json
    except Exception as e:
        print(e)
        abort(500, e)


@app.route("/render", methods=["POST"])
def render():
    url = request.form.get("url")
    # username = request.form.get("username")
    # password = request.form.get("password")
    background = request.form.get("background")

    if not url or not background:
        abort(400, "Bad request")

    # createTitleImage(url, username, password)

    rawVideo = createAudioWithImage()
    video = addBackgroundVideo(rawVideo, background)
    # video = addBackgroundMusic(video, rawVideo.duration)
    video = editVideo(video)
    video.write_videofile("output/output.mp4", fps=60)

    return_dict = {
        "path": os.path.abspath("output/output.mp4"),
    }
    return_json = json.dumps(return_dict)
    return return_json


if __name__ == "__main__":
    app.run(port=9811)
