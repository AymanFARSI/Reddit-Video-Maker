# Reddit Video Maker

This project is a Reddit Video Maker built with Dart and Flutter, it uses the Reddit API to scrape posts and convert them to videos using MoviePy, and it uses Flask to build the backend API.

## Features

- Scrape Reddit posts
- Select different voice options
- Customize video backgrounds
- Render videos

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter](https://flutter.dev/) - The cross-platform framework used
- [Dart](https://dart.dev/) - The programming language used
- [Reddit API](https://www.reddit.com/dev/api/) - The API used to scrape Reddit posts
- [MoviePy](https://zulko.github.io/moviepy/) - The library used to convert posts to videos
- [Flask](https://flask.palletsprojects.com/en/1.1.x/) - The framework used to build the backend API

### Installation

1. Clone the repo

```sh
git clone https://github.com/AymanFARSI/Reddit-Video-Maker.git
```

2. Install packages

```sh
flutter pub get
```

## Usage

- Run the backend API

```sh
python api.py
```

- Run the app

```sh
flutter run
```

- Build the app

```sh
flutter build windows
```

## Contributing

Any contributions you make are greatly appreciated.

1. Fork the Project

```sh
git clone https://github.com/AymanFARSI/Reddit-Video-Maker.git
```

2. Rename the forked project

> To avoid Flutter package naming issues

3. Recreate the project

```sh
flutter create .
```

4. Create your Feature Branch

```sh
git checkout -b feature/AmazingFeature
```

5. Commit your Changes

```sh
git commit -m 'Add some AmazingFeature'
```

6. Push to the Branch

```sh
git push origin feature/AmazingFeature
```

7. Open a Pull Request

> Make sure to add details of changes made and screenshots if possible

## License

Distributed under the MIT License. See `LICENSE` for more information.
