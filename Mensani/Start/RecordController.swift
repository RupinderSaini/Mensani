//
//  RecordController.swift
//  Mensani
//
//  Created by apple on 21/06/23.
//
import AVFoundation
import Alamofire
import UIKit
import SwiftyJSON

class RecordController: UIViewController , AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate{
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!

    @IBOutlet weak var txtAudio: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func btnsave(_ sender: Any) {
//        record_btn_ref.setTitle("Recorded", for: .normal)
//        if audioRecorder != nil
//        {
//            finishAudioRecording(success: true)
//        }
        getValues()
    }
    @IBOutlet weak var btnSave: UIButton!
    //    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var edName: UITextField!
    @IBOutlet weak var vRecord: UIView!
    @IBOutlet weak var vInner: UIView!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var strName = ""
    var callFrom = 0     // 0 = self , 1= visualization
    
    var  delegate : refreshAudioSelfVisual?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        edName.delegate = self
        indicator.isHidden = true
        check_record_permission()
       
        setBorder10(viewName: play_btn_ref, radius: 10)
        setBorder10(viewName: btnSave, radius: 10)
//        setBorder10(viewName: record_btn_ref, radius: 10)
        
        setBorder10(viewName: vRecord, radius: 10)
        setBorder10(viewName: edName, radius: 10)
        setBorder10(viewName: vInner, radius: 10)
        btnSave.isHidden = true
        play_btn_ref.isHidden = true
        edName.setLeftPaddingPoints(10)
        edName.setRightPaddingPoints(10)
      
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        record_btn_ref.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        edName.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        recordingTimeLabel.textColor = hexStringToUIColor(hex: color ?? "#fff456")
       
        txtAudio.text = LocalisationManager.localisedString("audio_name")
        record_btn_ref.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        play_btn_ref.setTitle(LocalisationManager.localisedString("stop"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
    }
    
    func getValues()
    {
        if let text = edName.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("audio_name"), Message: LocalisationManager.localisedString("enter_audio_namee"))
        }
        else
        {
            strName = (edName.text?.trimmingCharacters(in: .whitespaces))!
            uploadDocument()
        }
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
            })
            break
        default:
            break
        }
    }
    func setup_recorder() -> Bool
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                return true
            }
            catch let error {
                alertFailure(title: "Error", Message: error.localizedDescription)
            }
        }
        else
        {
           alertMicrophone()
            return false
        }
        return true
    }
    @IBAction func start_recording(_ sender: UIButton)
    {
        if(isRecording)
        {

        }
        else
        {
          let bool = setup_recorder()
            if bool {
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                //            record_btn_ref.setTitle("Recording", for: .normal)
                play_btn_ref.isEnabled = true
                play_btn_ref.isHidden = false
                
                isRecording = true
            }
            else
            {
                alertMicrophone()
            }
        }
    }

    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            alertFailure(title: "Error", Message: "Recording failed.")
        }
    }
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }

    @IBAction func play_recording(_ sender: Any)
    {
        
        if(isRecording)
        {
            finishAudioRecording(success: true)
//            record_btn_ref.setTitle("Record", for: .normal)
            play_btn_ref.isEnabled = true
            isRecording = false
            btnSave.isHidden = false
            btnSave.isEnabled = true
          isRecording = false
        }
//        if(isPlaying)
//        {
//            print("if playing clicked")
//            audioPlayer.stop()
//            record_btn_ref.isEnabled = true
//            play_btn_ref.setTitle("Play", for: .normal)
//            isPlaying = false
//        }
//        else
//        {
//            print("else clicked")
//            if FileManager.default.fileExists(atPath: getFileUrl().path)
//            {
//                record_btn_ref.isEnabled = false
//                play_btn_ref.setTitle("Re-start", for: .normal)
//                prepare_play()
//                audioPlayer.play()
//
//
//                isPlaying = true
//            }
//            else
//                    {
//                        display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
//                    }
//                }
        }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        play_btn_ref.isEnabled = true
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        record_btn_ref.isEnabled = true
//        audioPlayer.stop()
        record_btn_ref.isEnabled = true
        play_btn_ref.setTitle(LocalisationManager.localisedString("stop"), for: .normal)
        isPlaying = false
    }
    
   
    func uploadDocument()
    {
        
        let url = getFileUrl()
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        
        indicator.isHidden = false
        indicator.startAnimating()
        let lang = LocalData.getLanguage(LocalData.language)
        var APIName = ""
        if callFrom == 0
        {
           APIName = Constant.recordSelfAPI
        }
        else
        {
            APIName = Constant.recordVisualAPI
        }
print(Constant.baseURL + APIName)
        let parameters = ["audio_name": strName , "lang" : lang , "type" : "0"]
        print(parameters)
        AF.upload(
            multipartFormData: { multipartFormData in
                     multipartFormData.append(url, withName: "recording" , fileName: "record.mp3", mimeType: "*/*")
               
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                print(multipartFormData)
            },
            to: Constant.baseURL + APIName, method: .post, headers: header)
            //    .response { response in
        .responseJSON { (response) in
            print("response reocrd")
            print(response)
            
            switch response.result{
            case .success:
                print("Validation Successful)")
                
                if let json = response.data {
                    do
                    {
                        let data = try JSON(data: json)
                   
                        let status = data["status"]
                      
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        
                        if("\(status)" == "1")
                        {
                            self.delegate!.refreshList()
                            self.dismiss(animated: true)
                        }
                        else
                        {
                            let message = data["message"]
                            self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(message)")
                            self.indicator.stopAnimating()
                            self.indicator.isHidden = true
                        }
                    }
                    catch
                    {
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        print("JSON Error", error)
                        //    self.alertUI(title: "Invalid json", Message: "\(error)")
                    }
                }
            case .failure(let error):
                print(error)
//                self.btnUpdate.isEnabled = true
            // self.alertUI(title: "Invalid faliure", Message: "\(error)")
            }
        }
    }
}

protocol refreshAudioSelfVisual
{
    func refreshList()
}
