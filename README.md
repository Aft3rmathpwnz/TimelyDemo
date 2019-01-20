# TimelyDemo
Demo app with time entries table, new entries sessional adding using Google's MLKit.
Actually, MLKit's client OCR performs pretty poor for handwritten text, but mostly it stands for proof of concept here. Use case: person noted his work track/note on the paper and wanted to add it in app.

To run app on your device you should:
1) Run ```pod install``` command from folder containig Podfile;
2) Change bundle identifier so XCode could generate provisioning profile for you;
3) Add firebase to your project as described here: https://firebase.google.com/docs/ios/setup. Remember to add GoogleService-Info.plist file to project.

![](TimelyDemo_GIF.gif) ![](TimelyDemo2_GIF.gif)

DISCLAIMER: I hereby declare that I do not own the rights to "Timely" trademark. All rights belong to the owner. No Copyright Infringement Intended.
