# IMU x Video

* Open FYP.xcodeproj using XCode
* Connect you iOS device and choose the device at the selector near "Run" button
* Run it on the device

## Description
This is an swift based APP developed by [jasonhu5](https://github.com/jasonhu5). We modified it to capture the IMU data and video with iOS devices (e.g. iPhone 6s).

## Usage
**macOS with Xcode, iTunes and iOS devices (iPhone, iPad, iPod Touch) are needed.**
  
+ Connect the phone to the Mac.  
+ Build and install the app.  
+ After capturing the data, connect the device to PC, and open iTunes to extract the recorded data. Which includes:
	+ An ```.mp4``` video.
	+ An ```txt``` file which indicates the time when it began and when it ended.
	+ An ```.csv``` file includes the IMU data. (Accelerations and rotations)    

P.S. You can change the type of data you want to capture by modifiying the variables in ```ViewController.swift``` .

### Refs
[Stackoverflow: How to record a video with avfoundation in Swift?](http://stackoverflow.com/questions/33249041/how-to-record-a-video-with-avfoundation-in-swift)
