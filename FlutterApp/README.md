Readme

# Flutter app for Insurance Predictor

This Flutter app demonstrates a simple UI that calls the `POST /predict` endpoint of your FastAPI service and shows the predicted value.

How to run
1. Install Flutter on your machine and ensure `flutter` is available in your PATH.
2. From this folder run:

```bash
cd flutter_app
flutter pub get
flutter run
```

Notes about API URL
- Open `lib/main.dart` and set the `apiBaseUrl` constant at the top. Default is `http://10.0.2.2:8000` (for Android emulator). For iOS simulator use `http://localhost:8000` or set the public Render URL if deployed.

UI
- The app has two pages: the Home form page (inputs for `age`, `bmi`, `smoker`, `region`) and a Result page which shows the numeric prediction.

