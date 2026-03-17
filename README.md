# GroceryVault Flutter

**GroceryVault Flutter** is a modern cross-platform grocery management app built using **Flutter, Firebase, and Clean Architecture principles**.  
It supports **secure user-based storage, cloud backup, and offline-first data handling**.

The app demonstrates **real-world mobile development practices**, including authentication, local persistence, background sync, and scalable architecture.

---

## ✨ Features

- Firebase Authentication (Email/Password)
- Per-user data isolation
- Add, edit, and delete grocery items
- Attach images from gallery
- Offline-first architecture
- Cloud backup using Firestore
- Manual backup using file picker (Google Drive, etc.)
- Share backup via system share sheet
- Clean and intuitive UI
- Cross-platform (Android & iOS)

---

## 🧠 Architecture

The app follows a **Clean Architecture inspired structure**.

```
lib/
│
├── presentation
│   ├── screens
│   ├── widgets
│   └── state
│
├── domain
│   ├── models
│   ├── repositories
│   └── usecases
│
├── data
│   ├── local
│   ├── remote
│   └── repository
```

---

## 🔄 Data Flow

```
UI → State Management → UseCase → Repository → Local / Firebase
```

- Local-first approach
- Sync with Firestore
- Reactive UI updates

---

## 📦 Tech Stack

- Flutter (Dart)
- Firebase Authentication
- Firebase Firestore
- Firebase Storage
- Bloc / State Management
- GoRouter
- Material UI
- Image Picker
- File Handling APIs

---

## ☁️ Backup System

GroceryVault supports:

### Cloud Backup
- Stores data in Firestore
- Path: `users/<uid>/backups/latest`

### Local Backup
- Export JSON via file picker

### Share Backup
- Share JSON via apps (Drive, Gmail, etc.)

---

## 🔐 Firebase Setup

1. Go to **Firebase Console**
2. Create a project
3. Add Android & iOS apps

### Android Setup

- Add `google-services.json` to:

```
android/app/
```

### iOS Setup

- Add `GoogleService-Info.plist` to:

```
ios/Runner/
```

### Enable Services

- Authentication → Email/Password
- Firestore Database → Create database

---

## ▶️ Run the App

```
flutter pub get
flutterfire configure
flutter run
```

---

## 🛠 Project Goals

This project demonstrates:

- Cross-platform app development with Flutter
- Firebase integration
- Offline-first architecture
- Scalable code structure
- Real-world app features

---

## 🚀 Future Improvements

- Real-time sync
- Multi-device sync handling
- Cloud image storage
- Push notifications
- Advanced filtering & search

---

## 👨‍💻 Author

**Sridhar Prasath**

Android / Flutter / iOS Developer

GitHub:  
https://github.com/sridharprasath94

---

## 📄 License

This project is licensed under the MIT License.
