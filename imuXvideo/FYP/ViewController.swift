//
//  ViewController.swift
//  FYP
//
//  Created by Jason HSJ on 9/1/2017.
//  Copyright © 2017 Jason, HU. All rights reserved.
//

import UIKit
// gyro, acc
import CoreMotion
// compass
import CoreLocation
// video
import AVFoundation
// real time debugging
import SocketIO


extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "zh_HK_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 8*3600)
            formatter.dateFormat = "yyMMdd'T'HHmmss"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}

class ViewController: UIViewController,
CLLocationManagerDelegate,
AVCapturePhotoCaptureDelegate,
AVCaptureFileOutputRecordingDelegate
{
    
//    @IBOutlet var imu_acc_x: UITextView!
//    @IBOutlet var imu_acc_y: UITextView!
//    @IBOutlet var imu_acc_z: UITextView!
    
//    @IBOutlet var imu_gyro_x: UITextView!
//    @IBOutlet var imu_gyro_y: UITextView!
//    @IBOutlet var imu_gyro_z: UITextView!
    
    @IBOutlet var imu_motion_roll: UITextView!
    @IBOutlet var imu_motion_pitch: UITextView!
    @IBOutlet var imu_motion_yaw: UITextView!
    
    @IBOutlet var magnetic_heading: UITextView!
    
    @IBOutlet var btn_start: UIButton!
    @IBOutlet var btn_begin_session: UIButton!
    
    @IBOutlet var switch_show: UISwitch!
    
    @IBOutlet var label_recording: UILabel!
    
    @IBOutlet var label_video_write: UILabel!
    @IBOutlet var switch_video_write: UISwitch!
    
    var timerObj: Timer!
    
    var IS_RECORDING: Bool! = false
    
    var motionManager:CMMotionManager!
    var locManager:CLLocationManager!
    
    var moveArr: Array<Array<Double>>!
    var startDateTime: String!
    var startTimeStamp: Int!
    var finishDateTime: String!
    var finishTimeStamp: Int!
    
    var err: NSError? = nil
    
    func hideNums() {
        self.imu_motion_pitch.isHidden = true
        self.imu_motion_roll.isHidden = true
        self.imu_motion_yaw.isHidden = true
        self.magnetic_heading.isHidden = true
    }
    
    func showNums() {
        self.imu_motion_pitch.isHidden = false
        self.imu_motion_roll.isHidden = false
        self.imu_motion_yaw.isHidden = false
        self.magnetic_heading.isHidden = false
    }
    
    @IBAction func switchVideoRecording(_ sender: Any) {
        if (self.switch_video_write.isOn) {
            self.label_video_write.isHidden = false
        } else {
            self.label_video_write.isHidden = true
        }
    }
    @IBAction func switchFlipped(_ sender: Any) {
        if (self.switch_show.isOn) {
            showNums()
        } else {
            hideNums()
        }
    }
    
    // video part
    @IBOutlet var camView: UIView!
    
//    var captureSession = AVCaptureSession()
//    var previewLayer = AVCaptureVideoPreviewLayer()
//    var videoFileOutput = AVCaptureMovieFileOutput()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoFileOutput: AVCaptureMovieFileOutput!
    
    @IBAction func beginCaptureSession(_ sender: Any) {
        
        self.captureSession = AVCaptureSession()
        self.previewLayer = AVCaptureVideoPreviewLayer()
        self.videoFileOutput = AVCaptureMovieFileOutput()
        
        // camera starts refressing
        self.captureSession.startRunning()
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDualCamera, AVCaptureDeviceType.builtInTelephotoCamera, AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        
        for device in (deviceDiscoverySession?.devices)! {
            if(device.position == AVCaptureDevicePosition.back){
                print("debug: found back camera")
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    print("debug: can shoot video")
                    beginSession(captureDevice: device)
                }
            }
        }
        
        self.switch_show.isHidden = false
        self.btn_start.isHidden = false
        self.label_recording.isHidden = false
        self.btn_begin_session.isHidden = true
        self.btn_sock_conn.isHidden = false
        self.switch_video_write.isHidden = false
        self.label_video_write.isHidden = false
    }
//    override func viewWillAppear(_ animated: Bool) {
//         set orientation of device to landscapeleft
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
//    }
    
    func beginSession(captureDevice: AVCaptureDevice) {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("jsnh: failed to add input from device")
        }
        print("debug: started session")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        previewLayer.frame = self.camView.layer.frame
        self.camView.layer.addSublayer(previewLayer)
        self.camView.bringSubview(toFront: self.imu_motion_yaw)
        self.camView.bringSubview(toFront: self.imu_motion_roll)
        self.camView.bringSubview(toFront: self.imu_motion_pitch)
        self.camView.bringSubview(toFront: self.magnetic_heading)
        self.camView.bringSubview(toFront: self.btn_start)
        self.camView.bringSubview(toFront: self.label_recording)
        self.camView.bringSubview(toFront: self.switch_show)
        self.camView.bringSubview(toFront: self.switch_video_write)
        self.camView.bringSubview(toFront: self.label_video_write)
        self.camView.bringSubview(toFront: self.btn_sock_conn)
        
        self.captureSession.addOutput(videoFileOutput)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func recordVideo() {
        let data_file = self.startDateTime + "video.mp4"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let data_path = dir.appendingPathComponent(data_file)
            
            videoFileOutput.startRecording(toOutputFileURL: data_path, recordingDelegate: self)
        }
    }
    
    var socket: SocketIOClient!
    @IBOutlet var btn_sock_conn: UIButton!
    var sock_ip_port: String = "http://"
    var is_sock_connected: Bool = false
    
    @IBAction func connect_sock(_ sender: Any) {
        // let is_sock_connected = self.btn_sock_conn.currentTitle == "Connected"
        
        if self.is_sock_connected {
            self.socket.disconnect()
        } else {
            let alert = UIAlertController(title: "IP:Port", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textFiled) in
                textFiled.text = self.sock_ip_port
            })
            
            alert.addAction(UIAlertAction(title: "Connect", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(textField?.text)")
                self.sock_ip_port = (textField?.text)!
                self.initSocketConnection(addr: self.sock_ip_port)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func initSocketConnection(addr: String) {
        self.socket = SocketIOClient(socketURL: URL(string: addr)!, config: [.log(true), .forcePolling(true)])
        
        self.socket.on("connect") {data, ack in
            self.btn_sock_conn.setTitle("Disconnect", for: .normal)
            self.is_sock_connected = true
        }
        
        self.socket.on("disconnect") {data, ack in
            self.btn_sock_conn.setTitle("Connect", for: .normal)
            self.is_sock_connected = false
        }
        
        self.socket.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initialize IS_RECORDING and hide recording label
        
        self.IS_RECORDING = false
        self.label_recording.isHidden = true
        
        // default do not show the debug items
        self.switch_show.setOn(false, animated: true)
        hideNums()
        
        self.motionManager = CMMotionManager()
        self.locManager = CLLocationManager()
        
        self.moveArr = [[Double]]()
        
        self.switch_show.isHidden = true
        self.btn_start.isHidden = true
        self.label_recording.isHidden = true
        
        self.switch_video_write.isHidden = true
        self.label_video_write.isHidden = true
        self.btn_sock_conn.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopUpdates() {
        //        self.motionManager.stopAccelerometerUpdates()
        //        self.motionManager.stopGyroUpdates()
        self.motionManager.stopDeviceMotionUpdates()
        self.locManager.stopUpdatingHeading()
    }
    
    func startUpdates() {
        //        self.motionManager.accelerometerUpdateInterval = 0.2
        //
        //        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {_,_ in
        //            if let accelerometerData = self.motionManager.accelerometerData {
        //                self.updateAcc(accelerometerData: accelerometerData)
        //            }
        //        })
        //
        //        self.motionManager.gyroUpdateInterval = 0.1
        //
        //        self.motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {_,_ in
        //            if let gyroData = self.motionManager.gyroData {
        //                self.updateGyro(gyroData:gyroData)
        //            }
        //        })
        
        self.motionManager.deviceMotionUpdateInterval = 0.1
        
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {_,_ in
            if let motionData = self.motionManager.deviceMotion {
                self.updateMotion(motionData: motionData)
            }
        })
        
        self.locManager.delegate = self
        self.locManager.startUpdatingHeading()
        
        print("start")
    }
    
    // MARK: -
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed: \(error)")
    }
    
    // Heading readings tend to be widely inaccurate until the system has calibrated itself
    // Return true here allows iOS to show a calibration view when iOS wants to improve itself
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    // This function will be called whenever your heading is updated. Since you asked for best
    // accuracy, this function will be called a lot of times. Better make it very efficient
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //        print(newHeading.magneticHeading)
        //        print("hello")
        self.magnetic_heading.text = String(format:"%f", newHeading.magneticHeading)
    }
    
    func updateMotion(motionData:CMDeviceMotion) {
        let x = motionData.userAcceleration.x
        let y = motionData.userAcceleration.y
        let z = motionData.userAcceleration.z
        let xx = motionData.rotationRate.x
        let yy = motionData.rotationRate.y
        let zz = motionData.rotationRate.z
        self.imu_motion_roll.text = String(format:"%f", xx)
        self.imu_motion_pitch.text = String(format:"%f", yy)
        self.imu_motion_yaw.text = String(format:"%f", zz)
        
        // record movement data in the array
        self.moveArr.append([Double(Date().timeIntervalSince1970*1000.0), x, y, z, xx, yy, zz])
    }
    
    func runTimedCode() {
        let x = Int(self.label_recording.text!)
        self.label_recording.text = String(x! + 1)
    }
    
    
    // start updates and record in array
    @IBAction func startRecording(_ sender: AnyObject) {
        if (self.IS_RECORDING!) {
            self.finishDateTime = Date().iso8601
            self.finishTimeStamp = Int(Date().timeIntervalSince1970)
            
            // write to file, comment if testing functionality
            if (self.switch_video_write.isOn) {
                // write imu data to file
                self.writeToFile()
                
                // stop video recording
                self.videoFileOutput.stopRecording()
            }
            
            // stop imu updates
            self.stopUpdates()
            
            // clear movedata after exporting
            self.moveArr.removeAll()
            
            // stop timer
            self.timerObj.invalidate()
            // toggle button
            self.btn_start.setTitle("Start", for: .normal)
            self.btn_start.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            // toggle IS_RECORDING and label
            self.IS_RECORDING = false
            self.label_recording.isHidden = true
        } else {
            // toggle IS_RECORDING and recording label
            self.IS_RECORDING = true
            self.label_recording.text = "0"
            self.label_recording.isHidden = false
            // toggle button
            self.btn_start.setTitle("Finish", for: .normal)
            self.btn_start.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            self.timerObj = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            
            // make sure previous data all removed
            self.moveArr.removeAll()
            self.startDateTime = Date().iso8601
            self.startTimeStamp = Int(Date().timeIntervalSince1970)
            
            // start imu recording
            self.startUpdates()
            
            // start videoRecording
            if (self.switch_video_write.isOn) {
                self.recordVideo()
            }
        }
    }
    
    func prepCSV()-> String {
        var str = ""
        for row in self.moveArr {
            for i in 0 ... 6 {
                if (i < 6) {
                    str += String(row[i]) + ","
                } else {
                    str += String(row[i])
                }
            }
            str += "\n"
        }
        return str
    }
 
    // actually write data to appFiles
    func writeToFile() {
        let data_file = self.startDateTime + "X" + finishDateTime + "data.csv" //this is the data file.
        let info_file = self.startDateTime + "X" + finishDateTime + "info.txt" //this is the extra info file.
        
        let info = String(startTimeStamp) + "," + String(finishTimeStamp)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let data_path = dir.appendingPathComponent(data_file)
            
            //writing data
            do {
                try prepCSV().write(to: data_path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
            
            let info_path = dir.appendingPathComponent(info_file)
            
            //writing data
            do {
                try info.write(to: info_path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    // functions for AVCaptureFileOutputRecordingDelegate protocols
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        return
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        return
    }
}


