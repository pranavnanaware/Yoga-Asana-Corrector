This project had been recently migrated to Flutter 3.0 and might not work for some users.

Thanks for your love and support! 🫶🏻

---

[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

# Yoga Asana Detector

**Yoga Asana Detector** is your personalized yoga trainer app based on Flutter. It uses posenet, a pre-trained deep learning model, to estimate body poses in real time and predict yoga asanas.

## Getting Started

### Step 1: Clone the project repository

Open terminal and type

```sh
git clone https://github.com/pranavnanaware/Yoga-Asana-Corrector.git
```

### Step 2: Run the app

Connect your device or start the emulator and run the following code

```sh
# change directories
cd yoga_asana

# gets all the dependencies
flutter pub get

# run the app
flutter run
```

## Project Structure

The project structure is quite primitive right now.

Don't worry, we'll take a brief look at all the files in a minute! Let's start with **main.dart**

### 1. main.dart

**main.dart** loads data from shared preferences and the camera module. It also defines routes for **home**, **login** and **register** pages. If the user is already logged in, it sets the initial route to **home.dart** else **login.dart**.

### 2. login.dart

**login.dart** defines a _Login_ class, which is a stateful widget. It contains the textfields required to login into the app. The Login button calls the _\_login()_ method which routes to **home.dart**. Also contains a button to send the user to **register.dart**.

### 3. register.dart

**register.dart** defines a _Register_ class, which is a stateful widget. It contains the textfields required to login into the app. The Login button calls the _\_register()_ method which routes to **home.dart**. Also contains a button to send the user to **login.dart**.

### 4. home.dart

**home.dart** defines a _Home_ class, which is a stateless widget. It contains buttons which routes the user to **poses.dart** according to the button they press. Each button (beginner, intermediate, advance) call a method _\_onPoseSelect()_.

This _\_onPoseSelect()_ method is quite important as the arguments given to this function decides which list of poses needs to be shown on the poses page.

<br /><br /><br />

### 5. poses.dart

**poses.dart** defines a _Poses_ class, which is a stateless widget. It shows a list of available poses as [swipable cards](https://pub.dev/packages/flutter_swiper). The code of the custom cards can be found in **yoga_card.dart** file. Each card is clickable and calls the _\_onSelect()_ method which directs the user to the InferencePage (**inference.dart**).

<br /><br /><br /><br /><br />

### 6. inference.dart

**inference.dart** defines a _InferencePage_ class, which is a stateful widget. It is the class which loads the posenet model. It initializes the Camera object with the camera instance and _\_setRecognitions()_ callback function. The _\_setRecognitions()_ method is responsibe for saving the predicted output of the PoseNet model into a List (_\_recognitions_). This list of predicted values (_\_recognitions_) is then passed to **BndBox's** constructor.

You can read more about the implementation [here](https://github.com/shaqian/flutter_tflite#posenet).

<br /><br />

### 7. camera.dart

**camera.dart** defines a _Camera_ class, which is a stateful widget. It contains code related to camera initialization and calls _Tflite.runPoseNetOnFrame()_ method by passing in the current _CameraImage_ as an argument. The output (predictions) of this method is given as an argument to the _\_setRecognitions()_ method, which was passed to Camera() as callback.

### 8. bndbox.dart

**bndbox.dart** defines a _BndBox_ class, which is a stateless widget. It takes the List of predictions (_\_recognitions_) and plot keypoints on the screen. It also prints the accuracy of the model in %.

### 9. profile.dart

**profile.dart** defines a _Profile_ class, which is a stateful widget. It contains the code for viewing and updating the user's profile data.

<br /><br /><br /><br /><br /><br />

## Support

<a href="https://www.buymeacoffee.com/iBZjXRz" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

Reach out to me at any of the following platforms:

- Portfolio Website: [Pranav Nanaware](https://pranavnanaware.vercel.app)
- Email: [nanawarepranav@gmail.com](mailto:nanawarepranav@gmail.com)
- LinkedIn: [pranavnanaware](https://www.linkedin.com/in/pranavnanaware/)

## Resources to help you start

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
