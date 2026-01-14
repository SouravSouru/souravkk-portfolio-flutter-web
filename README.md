
# Portfolio - Yoush KK

Professional Flutter Web Portfolio for Senior Flutter Developer.

## Features
- **Clean Architecture**: Organized feature-based folder structure.
- **Responsive Design**: Mobile-first approach using `LayoutBuilder` and `MediaQuery`.
- **State Management**: `flutter_bloc` for theme management.
- **Routing**: `go_router` for navigation.
- **Theming**: Dark and Light mode support.

## Getting Started

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run Locally**:
    ```bash
    flutter run -d chrome
    ```

## Build & Deployment

### 1. Build for Web
Run the following command to generate the release build:
```bash
flutter build web --release --web-renderer html
```
*Note: `html` renderer is often preferred for portfolios to ensure smaller download size and better SEO text rendering compared to `canvaskit`, but `canvaskit` offers better performance. Remove `--web-renderer html` to use auto/canvaskit.*

### 2. Deploy to Firebase
1.  Install firebase tools: `npm install -g firebase-tools`
2.  Login: `firebase login`
3.  Initialize: `firebase init` (Select Hosting, use `build/web` as public directory).
4.  Deploy: `firebase deploy`

### 3. Deploy to GitHub Pages
1.  Build:
    ```bash
    flutter build web --base-href "/<repo-name>/"
    ```
2.  Push contents of `build/web` to `gh-pages` branch.
    *Reference: [flutter_gh_pages](https://pub.dev/packages/flutter_gh_pages)*

### 4. Deploy to Netlify
1.  Drag and drop `build/web` folder to Netlify Drop.
