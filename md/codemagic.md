# Codemagic CI/CD Setup for Flutter Todo App

## Project Info
- **Repo**: github.com/arifsl65/flutter-todo-app
- **App Path**: `todo_app/` (monorepo structure)
- **Branch**: master

## Current Status
- Codemagic account connected via GitHub
- App detected and configured
- **Issue**: Android build failing due to Gradle version mismatch
- **Next Step**: Disable Android, build iOS only for TestFlight

## Codemagic Settings
- **URL**: https://codemagic.io/app/6a01a73c5d531dff343a4adf
- **Workflow**: Default Workflow
- **Build Machine**: macOS M2 (Mac mini)

## Build Configuration Needed
1. Go to Settings in Codemagic
2. Under "Build for platforms", uncheck Android
3. Keep only iOS checked
4. Start new build

## For iOS TestFlight
Requirements:
- Apple Developer Account ($99/year)
- App Store Connect integration in Codemagic
- Code signing certificates/provisioning profiles

### Steps to Set Up TestFlight:
1. In Codemagic > Settings > Code signing
2. Connect App Store Connect (API key)
3. Add iOS signing certificates
4. Enable "Publish to TestFlight" in publishing settings

## Files Created
- `todo_app/codemagic.yaml` - CI/CD configuration (3 workflows: android, ios, ios-testflight)
- `todo_app/integration_test/` - Integration tests
- `todo_app/lib/services/todo_service.dart` - Abstract service for DI

## Known Issues
1. **Gradle Version**: Codemagic uses AGP 8.9+ which needs Gradle 8.9. Project has AGP 8.7.0.
   - Fix: Update `android/settings.gradle` AGP version to 8.9.0
   - Or: Skip Android builds for now

## Commands Reference
```bash
# Run widget tests locally
flutter test

# Run integration tests (needs emulator)
flutter test integration_test/app_test.dart -d emulator-5554

# Run real Firebase DB tests
flutter test integration_test/real_db_test.dart -d emulator-5554
```
