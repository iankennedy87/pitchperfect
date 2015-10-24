//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ian Kennedy on 10/16/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!


    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        recording.hidden = true
        tapToRecord.hidden = false
        
        pauseButton.hidden = true
        resumeButton.hidden = true

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tapToRecord.hidden = false
        
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true

    }

    @IBAction func recordAudio(sender: UIButton) {

        recordButton.enabled = false
        
        tapToRecord.hidden = true
        recording.hidden = false
        
        pauseButton.hidden = false
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecorder(sender: UIButton) {
        audioRecorder.pause()
        pauseButton.hidden = true
        resumeButton.hidden = false
        recording.hidden = true
    }
    
    @IBAction func resumeRecorder(sender: UIButton) {
        resumeButton.hidden = true
        pauseButton.hidden = false
        recording.hidden = false
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        recording.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(inputFilePathUrl: recorder.url, inputTitle: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            tapToRecord.hidden = false
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}
