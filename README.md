# iOS Notification Debugging Tools

A quick solution for sending notifications to jailbroken iOS devices for testing tweaks. Based on the MultipeerConnectivity framework.

It was written during an all-nighter while trying to make marketing images for a tweak so it is not written well (esp. serialization stuff). The UI is rudimentary, so feel free to improve if you can!

## Features

- Send notifications from your Mac to test
- Spoof your notification as from a bundle identifier
- Queue notifications on device at intervals for videos
- Clear already sent notifications
- Load notification lists from files
- No setup required after installation
- Spoof carrier name and time
- Relaunch SpringBoard remotely

## Setup

1. Install tweak on device with `make install` (Theos required)
2. Open `Mac app/iOS Notification Debugging Tools.xcodeproj`
3. Run the Xcode project to build the Mac app
4. Select your iOS device from the Mac app (must be on same network)

## Contributing

Please feel free to improve the tool as much as you'd like and pull request back. Attempt to maintain a readable and similar coding style and use the same conventions as present already.

## Goals

Check out the [issues page](../../issues) to see what we have in mind for the future of this project.
