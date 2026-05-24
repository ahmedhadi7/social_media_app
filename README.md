📱 The Wall — Social Media App
A full-stack social media mobile application built with Flutter and Firebase, featuring real-time posts, likes, comments, and user profiles.

🚀 Features

🔐 Authentication — Register & Login with Email/Password via Firebase Auth
📝 Wall Posts — Create and delete posts in real-time
❤️ Like System — Like/Unlike posts with live counter
💬 Comments — Add comments to any post, displayed in real-time
👤 Profile Page — View and edit username & bio
🗂️ Drawer Navigation — Side menu for Home, Profile, and Logout
⚡ Real-time Updates — All data syncs instantly using Firestore Streams

🛠️ Tech Stack
TechnologyUsageFlutterUI FrameworkDartProgramming LanguageFirebase AuthUser AuthenticationCloud FirestoreReal-time Database

🗄️ Firebase Database Structure
Firestore
├── Users (collection)
│   └── {user@email.com} (document)
│       ├── username: String
│       └── bio: String
│
└── User Posts (collection)
    └── {postId} (document)
        ├── UserEmail: String
        ├── Message: String
        ├── TimeStamp: Timestamp
        ├── Likes: Array<String>        ← list of emails who liked
        └── Comments (sub-collection)
            └── {commentId} (document)
                ├── CommentText: String
                ├── CommentBy: String
                └── CommentTime: Timestamp

📁 Project Structure
lib/
├── main.dart
├── auth/
│   ├── auth.dart                  # Auth state listener
│   └── login_or_register.dart     # Toggle between Login/Register
├── pages/
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   └── profile_page.dart
├── component/
│   ├── wall_post.dart             # Post card with likes & comments
│   ├── comment.dart
│   ├── like_button.dart
│   ├── comment_button.dart
│   ├── delete_button.dart
│   ├── drawer.dart
│   ├── button.dart
│   ├── text_field.dart
│   ├── text_box.dart
│   └── my_list_tile.dart
└── helper/
    └── helper_method.dart         # Date formatting utility




⚙️ Getting Started
Prerequisites

Flutter SDK >=3.0.0
Dart SDK
Firebase project (with Auth & Firestore enabled)

Installation
1. Clone the repository
bashgit clone https://github.com/your-username/social_media_app.git
cd social_media_app
2. Install dependencies
bashflutter pub get
3. Configure Firebase

Create a Firebase project at console.firebase.google.com
Enable Email/Password Authentication
Enable Cloud Firestore
Run FlutterFire CLI to generate firebase_options.dart:

bashdart pub global activate flutterfire_cli
flutterfire configure
4. Run the app
bashflutter run

🔒 Security Note
The following files contain sensitive keys and are excluded from version control:
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
Make sure these are listed in your .gitignore before pushing.

📸 Screenshots

Coming soon


🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

📄 License
This project is licensed under the MIT License.

👨‍💻 Author
Your Name

GitHub: @your-username
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
