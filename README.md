# QR Code Scanner App

## Overview

This Flutter app allows users to scan QR codes. It features a simple and intuitive user interface, guiding users to scan QR codes with ease. The app shows the scan results in a dialog and provides instructions for users.

## Features

- QR code scanning functionality.
- Responsive UI with instructions for scanning.
- Dialog display for scan results.
- Throttle mechanism to prevent rapid reopening of the result dialog.
- Handles camera permissions gracefully.

## Screenshots

![Home Screen](assets/qr%20screen%20rec.mp4)
![QR Scanner](assets/qr%20screenshot.jpg)

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/qr-code-scanner-app.git
   cd qr-code-scanner-app

## Install dependencies:

flutter pub get

## Usage

1. Launch the app.
2. Point the camera at a QR code.
3. Wait for the QR code to be scanned and see the result in the dialog.

## Code Structure

main.dart: Entry point of the application.
MyApp: Stateless widget setting up the MaterialApp.
MyHome: Stateful widget containing the QR scanner.
_MyHomeState: Manages the state and functionality of the QR scanner, including handling scan results and permissions.

## Dependencies

flutter
qr_code_scanner

## Customization

Logo Image: Replace assets/img.png with your desired logo image.
Texts: Modify instruction texts and dialog messages in the MyHome widget.

## Troubleshooting

Camera Permission: Ensure the app has camera permissions enabled.
Scan Area: Adjust the scanArea variable in _buildQrView for different screen sizes.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.
