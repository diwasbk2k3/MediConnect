# **MediConnect - Flutter Mobile App**

A comprehensive healthcare mobile application built with Flutter, designed to connect patients with hospitals and manage their medical appointments, health records, and personal health information.

## **Architecture**

MediConnect follows **Clean Architecture** principles with:

- **Features**: Independent, self-contained modules for each feature
- **Core**: Shared utilities, services, and business logic
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Dependency Injection**: Using Riverpod for DI and state management

## **Features**

- 🏥 **Hospital Search & Discovery** - Browse and find nearby hospitals
- 📅 **Appointment Management** - Book, reschedule, and manage medical appointments
- 👤 **User Profile & Authentication** - Secure login and profile management
- 📋 **Medical Reports** - Access and manage health records and medical reports
- 🤖 **AI Assistant** - Intelligent health assistant for guidance and support
- 📊 **Dashboard** - Personalized health dashboard with key information
- 🎯 **Smart Onboarding** - Guided setup for new users
- 📱 **Sensors Integration** - Support for device sensors to gather health metrics
  
## **Tech Stack**

### **Framework & Language**
- **Flutter** 3.9.2+ for cross-platform mobile development
- **Dart** programming language

### **State Management**
- **Flutter Riverpod** (^3.1.0) - Reactive state management and dependency injection

### **Local Storage**
- **Hive** (^1.1.0) - Fast and lightweight local database
- **Shared Preferences** (^2.5.4) - Simple key-value storage

### **Networking**
- **Dio** (^5.9.0) - HTTP client with interceptors
- **JWT Decoder** (^2.0.1) - JWT token handling for authentication
- **Connectivity Plus** (^7.0.0) - Network connectivity detection

### **Security**
- **Flutter Secure Storage** (^10.0.0) - Secure credential storage

### **Device Integration**
- **Image Picker** (^1.2.1) - Pick images from gallery or camera
- **Permission Handler** (^12.0.1) - Handle device permissions
- **Sensors Plus** (^6.1.1) - Access device sensors

### **Data Serialization**
- **JSON Annotation** (^4.9.0) & **JSON Serializable** (^6.8.0)
- **Equatable** (^2.0.7) - Value equality

### **Utilities**
- **UUID** (^4.5.2) - Generate unique identifiers
- **Path Provider** (^2.1.5) - File system paths

## **Project Structure**

```
lib/
├── main.dart              # App entry point
├── app/                   # App-level configuration
├── features/              # Feature modules
│   ├── auth/             # Authentication
│   ├── appointment/      # Appointment management
│   ├── dashboard/        # User dashboard
│   ├── hospital/         # Hospital search & info
│   ├── profile/          # User profile
│   ├── report/           # Medical reports
│   ├── assistant/        # AI assistant
│   ├── sensors/          # Sensors integration
│   ├── onboarding/       # Onboarding flow
│   └── splash/           # Splash screen
└── core/                  # Core functionality
    ├── api/              # API client & configuration
    ├── constants/        # App constants
    ├── error/            # Error handling
    ├── services/         # Core services
    ├── usecase/          # Use cases / Business logic
    ├── utils/            # Utility functions
    └── widgets/          # Reusable widgets
```

## **Getting Started**

### **Prerequisites**
- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio / Xcode for mobile emulator
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd MediConnect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## **Development Commands**

- `flutter pub get` - Install dependencies
- `flutter pub run build_runner build` - Generate serialization code
- `flutter pub run build_runner watch` - Watch mode for code generation
- `flutter analyze` - Analyze code
- `flutter test` - Run unit tests
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

## **Testing**

Unit tests are available in the `test/` directory. Run tests with:

```bash
flutter test
```
