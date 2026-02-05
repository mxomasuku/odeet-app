# StockTake

<p align="center">
  <img src="assets/images/logo.png" alt="StockTake Logo" width="120"/>
</p>

**Stock taking and shop auditing software for Zimbabwean retail businesses.**

StockTake is a comprehensive, offline-first inventory management solution designed specifically for Zimbabwean retailers. It supports multi-shop management, local payment integrations (EcoCash, OneMoney, InnBucks), and works reliably even with unreliable internet connectivity.

## Features

### Core Features
- 📱 **Offline-First Architecture** - Works without internet, syncs when connected
- 🏪 **Multi-Shop Management** - Manage multiple shop locations from one account
- 📦 **Inventory Tracking** - Real-time stock levels with low-stock alerts
- 💰 **Sales Recording** - Quick POS with barcode scanning support
- 📊 **Comprehensive Reports** - Sales, profit, and inventory reports
- 🔄 **Stock Transfers** - Transfer stock between linked shops with 2-sided confirmation
- 💵 **Cash Collection Workflow** - Track cash handovers with dual confirmation
- 📈 **Price Management** - Track price changes with history

### Zimbabwean-Specific Features
- 🇿🇼 **Local Payment Integration** - EcoCash, OneMoney, InnBucks, Paynow
- 💱 **Multi-Currency Support** - USD, ZWL, ZAR, BWP
- 📱 **Mobile-First Design** - Optimized for smartphones
- 🌍 **Offline Capability** - Essential for areas with unreliable connectivity
- ⏰ **Africa/Harare Timezone** - Proper time handling for Zimbabwe

## Tech Stack

### Frontend (Flutter)
| Technology | Purpose |
|------------|---------|
| Flutter 3.2+ | Cross-platform UI framework |
| Riverpod | State management |
| Hive + SQLite | Local offline storage |
| GoRouter | Navigation |
| Freezed | Immutable data classes |
| Firebase Auth | Authentication |
| Cloud Firestore | Cloud database |

### Backend (Firebase + Node.js)
| Technology | Purpose |
|------------|---------|
| Cloud Functions | Serverless backend |
| Cloud Firestore | Real-time database |
| Firebase Auth | User authentication |
| Firebase Storage | File storage |
| Firebase Messaging | Push notifications |
| Paynow API | Zimbabwe payment gateway |

## Project Structure

```
stocktake/
├── lib/
│   ├── core/
│   │   ├── constants/       # App-wide constants
│   │   ├── errors/          # Custom exceptions & failures
│   │   ├── extensions/      # Dart extensions
│   │   ├── services/        # Core services (sync, connectivity)
│   │   └── utils/           # Utility functions
│   ├── data/
│   │   ├── datasources/     # Remote and local data sources
│   │   ├── models/          # Data models with Freezed
│   │   └── repositories/    # Repository implementations
│   └── presentation/
│       ├── controllers/     # Riverpod state controllers
│       ├── pages/           # Screen widgets
│       ├── widgets/         # Reusable widgets
│       ├── router/          # GoRouter configuration
│       └── theme/           # App theming
├── backend/
│   └── functions/
│       └── src/
│           ├── controllers/  # API controllers
│           ├── services/     # Business services
│           └── utils/        # Utility functions
├── assets/
├── test/
├── firebase.json
├── firestore.rules
└── pubspec.yaml
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.0.0
- Node.js >= 18
- Firebase CLI
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/stocktake.git
cd stocktake
```

2. **Install Flutter dependencies**
```bash
flutter pub get
```

3. **Generate code (Freezed, Riverpod, etc.)**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Set up Firebase**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (select existing project or create new)
firebase init
```

5. **Configure Firebase for Flutter**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

6. **Install backend dependencies**
```bash
cd backend/functions
npm install
cd ../..
```

7. **Run the app**
```bash
# Run on connected device/emulator
flutter run

# Or run with Firebase emulators
firebase emulators:start
flutter run
```

## Configuration

### Environment Variables
Create a `.env` file in the project root:
```env
PAYNOW_INTEGRATION_ID=your_integration_id
PAYNOW_INTEGRATION_KEY=your_integration_key
```

### Firebase Configuration
Update `firebase.json` with your project settings.

### Paynow Integration
1. Register at [Paynow](https://www.paynow.co.zw/)
2. Get your Integration ID and Key
3. Set up webhook URLs in Paynow dashboard

## Deployment

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
firebase deploy --only hosting
```

### Cloud Functions
```bash
cd backend/functions
npm run deploy
```

## Key Workflows

### Stock Transfer (2-Sided Confirmation)
1. Source shop creates transfer request
2. Source shop dispatches items
3. Destination shop receives and verifies items
4. Destination shop confirms receipt
5. Inventory automatically updated at both locations

### Cash Collection
1. Cashier submits cash count with denominations
2. System calculates variance from expected amount
3. Manager/collector verifies and collects
4. Admin confirms final reconciliation
5. Discrepancies flagged for investigation

### Offline Sync
1. All operations saved to local Hive database
2. Changes queued in sync queue
3. When online, queue processed in order
4. Conflicts resolved with last-write-wins
5. User notified of sync status

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License
This project is proprietary software. All rights reserved.

## Support
For support, email support@stocktake.co.zw or join our WhatsApp group.

---

**Made with ❤️ for Zimbabwean businesses**
