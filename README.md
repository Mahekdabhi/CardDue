# CardDue 💳

CardDue is a premium, offline-first personal **Credit Card Bill Reminder** Progressive Web App (PWA) built with **Flutter Web**, using **Clean Architecture + MVVM** and **Riverpod**.

Designed with Material 3 and Apple-inspired minimalist aesthetics, the app helps you manage multiple credit cards, track due dates, view outstanding balances, analyze credit utilization, and generate Apple Calendar event files—all completely locally and offline.

---

## 🌟 Key Features

*   **Premium Finance Dashboard**: Real-time metrics showing Total Outstanding, Total Credit Limit, and overall Credit Utilization (with warnings if utilization exceeds 30%).
*   **Virtual Credit Card Simulator**: Add or edit cards with a real-time visual credit card preview featuring custom premium gradient selectors.
*   **Offline-First & Local Storage**: 100% free and private. Data is stored entirely inside your browser's native **IndexedDB** using **Sembast NoSQL** database. No cloud, no database servers, no login.
*   **Manual Apple Calendar Reminders**: Generate and download standard-compliant `.ics` files containing payment dues and notes. Import them into your Apple Calendar with a single tap.
*   **Backup & Sync**: Export your entire database as a structured JSON backup file, and import it on any device to restore your data.
*   **Dynamic Theme Controls**: Persistent choice chips to toggle between Light Mode, Dark Mode, or System settings.
*   **Installable PWA**: Responsive mobile-first design, installable directly on iPhones or Androids to behave like a native application.

---

## 🛠️ Technical Stack

*   **Frontend Framework**: Flutter Stable (Material 3)
*   **State Management (MVVM ViewModels)**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
*   **Routing**: `go_router`
*   **Local Database**: Sembast NoSQL (`sembast`, `sembast_web`)
*   **Code Generation**: Freezed, Json Serializable
*   **Responsive Layouts**: `flutter_screenutil`
*   **Aesthetics & Fonts**: Google Fonts (Outfit & Inter), `flutter_animate`

---

## 📱 How to Install on iPhone (Safari PWA)

No App Store is required. Follow these steps to run CardDue as a native app:

1.  Open **Safari** on your iPhone.
2.  Navigate to your deployed GitHub Pages link: [https://mahekdabhi.github.io/CardDue/](https://mahekdabhi.github.io/CardDue/)
3.  Tap the **Share** button at the bottom of the screen.
4.  Scroll down the share sheet and tap **Add to Home Screen**.
5.  Tap **Add** in the top-right corner.
6.  Launch **CardDue** from your home screen!

---

## 🚀 Deployed with GitHub Actions (CI/CD)

This repository includes a preconfigured GitHub Actions workflow in `.github/workflows/deploy.yml` which builds the Flutter Web application and deploys it directly to GitHub Pages on every push to the `main` branch.

### Local Development Setup

To run this project locally:

1. Clone the repository.
2. Ensure Flutter is installed.
3. Run code generation:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run locally:
   ```bash
   flutter run -d chrome
   ```
