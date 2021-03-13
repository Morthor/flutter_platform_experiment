# flutter_platform_experiment

An experiment on using Flutter across multiple platforms with a websocket echo server propagating the messages across all connect clients (platforms).

## Getting Started

You will need to use a separate project running a very basic nodejs websocket server, which you can find here: [https://github.com/Morthor/node_basic_websocket](https://github.com/Morthor/node_basic_websocket).

### Get packages

`flutter pub get`

### Run on Android
`flutter run -d android`

### Run on iOS
`flutter run -d ios`

### Run on Web
`flutter config --enable-web`

`flutter create .`

`flutter run -d web`

### Run on Windows
`flutter config --enable-windows-desktop`

`flutter create .`

`flutter run -d windows`

### Run on Linux
`flutter config --enable-linux-desktop`

`flutter create .`

`flutter run -d linux`
### Run on MacOS
`flutter config --enable-macos-desktop`

`flutter create .`

`flutter run -d macos`

---
You can also run the app on the different platforms through the interface of Android Studio or Visual Studio Code.

