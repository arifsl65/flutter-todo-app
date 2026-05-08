# Project Initiation - Flutter + Go + Firebase Todo App

**Date:** 2026-05-08
**Platform:** Ubuntu Linux
**Purpose:** Learning project to understand Flutter, Go backend, and Firebase integration

---

## Project Overview

A simple Todo application built with:
- **Frontend:** Flutter (Mobile + Web)
- **Backend:** Go REST API
- **Database:** Firebase Firestore (real-time) + Go in-memory storage (for learning)

---

## Project Structure

```
Flutter_practise/
├── md/                          # Documentation
│   └── project_initiate.md
├── todo_app/                    # Flutter frontend
│   ├── pubspec.yaml
│   └── lib/
│       ├── main.dart            # App entry point with Firebase init
│       ├── main_local.dart      # Local testing without Firebase
│       ├── firebase_options.dart # Firebase configuration
│       ├── models/
│       │   └── todo.dart        # Todo data model
│       ├── screens/
│       │   └── todo_screen.dart # Main UI screen
│       └── services/
│           ├── firebase_service.dart    # Firebase Firestore CRUD
│           └── go_backend_service.dart  # Go REST API client
└── go_backend/                  # Go backend
    ├── go.mod                   # Go module definition
    └── main.go                  # REST API server
```

---

## Files Created

### 1. Flutter App (`todo_app/`)

#### `lib/main.dart`
- Initializes Firebase
- Sets up MaterialApp with Material Design 3
- Blue color scheme
- Routes to TodoScreen

#### `lib/main_local.dart`
- Self-contained local version (no Firebase needed)
- In-memory todo storage (no persistence)
- Same UI features: add, toggle, swipe-to-delete
- Useful for quick testing and learning Flutter basics
- Run with: `flutter run -t lib/main_local.dart -d chrome`

#### `lib/models/todo.dart`
- Todo class with: `id`, `title`, `completed`, `createdAt`
- Converters for Firebase (`fromMap`, `toMap`)
- Converters for Go backend (`fromJson`, `toJson`)
- `copyWith` method for immutability

#### `lib/screens/todo_screen.dart`
- Main UI with:
  - Text input to add new todos
  - ListView showing all todos
  - Checkbox to toggle completion
  - Swipe to delete (Dismissible)
  - Tap to edit (AlertDialog)
- Uses StreamBuilder for real-time Firebase updates

#### `lib/services/firebase_service.dart`
- Firestore integration
- Methods:
  - `getTodos()` - Stream of todos (real-time)
  - `addTodo(title)` - Create new todo
  - `toggleTodo(id, completed)` - Toggle completion
  - `updateTodo(id, title)` - Update title
  - `deleteTodo(id)` - Delete todo

#### `lib/services/go_backend_service.dart`
- HTTP client for Go backend
- Methods:
  - `getTodos()` - GET /todos
  - `addTodo(title)` - POST /todos
  - `toggleTodo(id, completed)` - PUT /todos/{id}
  - `deleteTodo(id)` - DELETE /todos/{id}

#### `lib/firebase_options.dart`
- Firebase configuration (configured via Firebase Console)
- Project ID: `todo-app-1911c`
- Web App ID: `1:218234223961:web:4b4187ab3487c38c462048`
- Firestore Database: `nam5` (United States)

#### `pubspec.yaml` dependencies added:
```yaml
firebase_core: ^3.8.0
cloud_firestore: ^5.5.0
http: ^1.2.0
```

---

### 2. Go Backend (`go_backend/`)

#### `main.go`
- Simple HTTP REST API server
- In-memory storage with mutex for thread safety
- CORS enabled for Flutter web
- Endpoints:
  - `GET /todos` - List all todos
  - `POST /todos` - Create todo
  - `PUT /todos/{id}` - Update todo
  - `DELETE /todos/{id}` - Delete todo
  - `GET /health` - Health check
- Runs on `http://localhost:8080`
- Includes sample todos on startup

#### `go.mod`
```go
module todo-backend
go 1.21
require github.com/google/uuid v1.6.0
```

---

## Setup Instructions

### Prerequisites
- Flutter SDK (installed via snap)
- Go (needs to be installed)
- Firebase account

### Step 1: Install Go
```bash
sudo snap install go --classic
```

### Step 2: Set up Firebase (COMPLETED)
Firebase has been configured with:
- **Project Name:** todo-app
- **Project ID:** todo-app-1911c
- **Web App:** todo-web (registered)
- **Firestore:** Enabled in test mode (nam5 - United States)

Configuration values are in `lib/firebase_options.dart`.

To add Android app later:
```bash
dart pub global activate flutterfire_cli
cd todo_app
flutterfire configure
```

### Step 3: Install Flutter Dependencies
```bash
cd todo_app
flutter pub get
```

### Step 4: Run Go Backend (Optional)
```bash
cd go_backend
go mod tidy
go run main.go
```
Server starts at `http://localhost:8080`

### Step 5: Run Flutter App
```bash
cd todo_app

# For web browser
flutter run -d chrome

# For Android emulator
flutter run

# List available devices
flutter devices
```

---

## Learning Concepts

### Flutter
| Concept | Where Used |
|---------|------------|
| StatefulWidget | `TodoScreen` |
| StreamBuilder | Real-time Firestore updates |
| Material Design 3 | Theme, AppBar, ListTile |
| Form handling | TextField, TextEditingController |
| Dismissible | Swipe to delete |
| AlertDialog | Edit todo popup |

### Go
| Concept | Where Used |
|---------|------------|
| HTTP server | `http.ListenAndServe` |
| Routing | `http.HandleFunc` |
| JSON encoding | `json.NewEncoder/Decoder` |
| Mutex | Thread-safe map access |
| Middleware | CORS handling |

### Firebase
| Concept | Where Used |
|---------|------------|
| Firestore | Cloud database |
| Real-time streams | `snapshots()` |
| Server timestamp | `FieldValue.serverTimestamp()` |
| CRUD operations | add, update, delete documents |

---

## Switching Between Backends

The app uses **Firebase by default**. To use the **Go backend** instead:

1. Edit `lib/screens/todo_screen.dart`
2. Replace `FirebaseService` with `GoBackendService`
3. Change from StreamBuilder to FutureBuilder (Go doesn't have real-time)

---

## To Do Next

### Immediate Tasks
- [ ] Install Go: `sudo snap install go --classic`
- [ ] Install Flutter dependencies: `cd todo_app && flutter pub get`
- [ ] Test Flutter app in browser: `flutter run -d chrome`
- [ ] (Optional) Run Go backend: `cd go_backend && go mod tidy && go run main.go`

### Quick Test (No Firebase needed)
```bash
cd todo_app
flutter run -t lib/main_local.dart -d chrome
```
This runs a local version without Firebase for quick testing.

### Full App with Firebase
```bash
cd todo_app
flutter pub get
flutter run -d chrome
```

---

## Next Steps (Ideas for Learning)

- [ ] Add user authentication (Firebase Auth)
- [ ] Add categories/tags to todos
- [ ] Add due dates
- [ ] Persist Go backend data to PostgreSQL
- [ ] Add unit tests
- [ ] Deploy Go backend to cloud (Railway, Fly.io)
- [ ] Build APK for Android

---

## Troubleshooting

### Java/Gradle version conflict
If you see Java version warnings when building for Android:
```bash
flutter config --jdk-dir=/path/to/java17
```

### Firebase not connecting
- `firebase_options.dart` is configured with project `todo-app-1911c`
- Firestore is enabled in test mode (allows read/write for 30 days)
- If issues persist, check Firebase Console for security rules

### Go backend connection refused
- Ensure Go server is running (`go run main.go`)
- For Android emulator, use `http://10.0.2.2:8080` instead of `localhost`
