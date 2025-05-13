# AxPlay  

![Flutter](https://img.shields.io/badge/flutter-3.19.2-blue.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-blue.svg)](LICENSE)

AxPlay is a video player application built with Flutter.  
This project was developed as part of my personal learning journey to explore Flutter's media playback capabilities, MVC architecture, custom UI design, and file system integration.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure-simplified-overview)
4. [Features](#features)
   1. [UI \& Layout](#ui--layout)
   2. [Video Playback](#video-playback)
   3. [Architecture \& Logic](#architecture--logic)
   4. [File Access \& Permissions](#file-access--permissions)
5. [Screenshots](#screenshots)
6. [Credits](#credits)
7. [License](#license)
8. [Author](#author)

---

## Getting Started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/anuragxep19/axplay_flutter.git
   cd axplay_flutter
   ```

1. **Install dependencies**:

   ```bash
   flutter pub get
    ```

1. **Run**:

    ```bash
    flutter run
    ```

---

## Tech Stack

- **Core Framework**: Flutter, Dart
- **Video Playback**: `video_player`
- **State Management**: `Provider`
- **Permission Handling**: `permission_handler`

---

## Project Structure (Simplified Overview)

```tree

axplay-flutter/
├── lib/                     # Main app source code
│   ├── controller/          # Business logic and controllers
│   ├── model/               # Data models and structures
│   ├── utils/               # Permission handling and responsive helpers
│   └── view/                # UI screens, widgets, and layout components
│
├── assets/                  # Static assets used in the app
│   ├── icons/               # App icons and logos
│   ├── readme/              # Images for README (e.g., screenshots)
│   ├── videos/              # Local MP4 files for testing playback
│   └── licenses/            # Auto-generated OSS licenses
│
├── pubspec.yaml             # Project dependencies and asset declarations
├── README.md                # Project documentation
├── LICENSE                  # License information (MIT)
└── .gitignore               # Files and folders to exclude from version control
                

```

---

## Features

### UI & Layout

- Gradient background with subtle glassmorphism
- Sliver-based scroll layout using CustomScrollView and SliverList

### Video Playback

- Asset video listing with thumbnail, duration, and title

- Video player with:

  - Auto-play and play/pause toggle

  - Progress slider with seek support

  - Current/Total duration display with remaining time toggle

  - Skip to next/previous video

  - 10-second forward/backward controls

  - Fullscreen mode with auto-hide toolbar

  - Exit fullscreen via back or fullscreen button

### Architecture & Logic

- MVC-style structure separating model, controller, and view
- State management using `provider`

### File Access & Permissions

- Asset-based video playback with metadata
- Access to videos from device storage (WIP for metadata extraction)
- Runtime prompts
  
---

## Screenshots

<details>
  <summary>Click to expand screenshots</summary>

  <br/>

  | Splash | Home |
  |:-----:|:----:|
  | <img src="assets/readme/splash.png" alt="Splash" width="200"/> |  <img src="assets/readme/home.png" alt="Home" width="200"/> |

  | Play | Fullscreen Play |
  |:---------------:|:----:|
  | <img src="assets/readme/play.png" alt="Play" width="200"/> | <img src="assets/readme/fullscreen_play.png" alt="Fullscreen Play" width="200"/> |

</details>

---

## Credits

- [Shields.io](https://shields.io/) – Used for project badges  
- [IconKitchen](https://icon.kitchen) – Helped generate the app’s logo assets  
- [Flutter](https://flutter.dev/) – Core framework for building the UI  

- [The open-source community](https://pub.dev/) – For architectural inspiration and reusable packages

---

## License

- **MIT License** – see [LICENSE](LICENSE)  
- **Third-Party Licenses** – see `assets/licenses/oss_licenses.json`

---

## Author

**Anurag E P**  
[GitHub: @anuragxep19](https://github.com/anuragxep19)  

---
