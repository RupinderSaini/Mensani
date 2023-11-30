//
//  SelfSetupController.swift
//  Mensani
//
//  Created by apple on 22/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation


class SelfSetupController: UIViewController,UIImagePickerControllerDelegate,
                           UINavigationControllerDelegate,  AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var vInner: UIView!
    var player : AVPlayer!
    @IBAction func btnCancel(_ sender: Any) {
        player.pause()
        txtTimePlay.text = "00:00:00"
        vPlay.isHidden = true
    }
    
    @IBAction func btnPlayAudio(_ sender: Any) {
        vPlay.isHidden = false
        play(url: audioURL!)
    }
    
    @IBOutlet weak var txtAudioName: UILabel!
    @IBOutlet weak var txtRecordn: UILabel!
    @IBOutlet weak var txtPrepar: UILabel!
    @IBOutlet weak var txtChal: UILabel!
    @IBOutlet weak var txtRoleModel: UILabel!
    @IBOutlet weak var txtHeading: UILabel!
    @IBOutlet weak var btnplayAudio: UIButton!
    @IBOutlet weak var vPlay: UIView!
    @IBAction func btnPlayPause(_ sender: Any) {
        if isPlaying
        {
            btnPlayPause.setImage(UIImage(systemName: "play.circle"), for: .normal)
            isPlaying = false
            player.pause()
            
        }
        else
        {
            btnPlayPause.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            isPlaying = true
            player.play()
        }
    }
    @IBAction func btnReset(_ sender: Any) {
        player.seek(to: .zero)
        btnPlayPause.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        isPlaying = true
        player.play()
    }
    
    @IBOutlet weak var btnPlayPause: UIButton!
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var txtTimePlay: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func btnSave(_ sender: Any) {
        if(currentReachabilityStatus != .notReachable)
        {
            getValues()
        }
        else{
            alertFailure(title: StringConstant.NO_INTERNET, Message: StringConstant.NO_INTER)
        }
    }
    @IBOutlet weak var btnSave: UIButton!
    @IBAction func btnStop(_ sender: Any) {
    }
  
    @IBOutlet weak var vRecord: UIView!
    @IBOutlet weak var vPreparing: UIView!
    @IBOutlet weak var txtChallange: UITextView!
    @IBOutlet weak var imgRole: UIImageView!
    @IBOutlet weak var edName: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    var imageContains = ""
    var filePath : URL? = nil
    var imageOrg : UIImage? = nil
    var imageoptionSelected = 0
    private let pickerController = UIImagePickerController()
    
    //recorder
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
var recordingDone = 0
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var audioURL  : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder10(viewName: txtChallange, radius: 10)
        setBorder10(viewName: vRecord, radius: 20)
        setBorder10(viewName: play_btn_ref, radius: 15)
        setBorder10(viewName: btnSave, radius: 20)
        setBorder10(viewName: btnReset, radius: 10)
        setBorder10(viewName: btnplayAudio, radius: 10)
        setBorder10(viewName: edName, radius: 10)
        setBorder10(viewName: indicator, radius: 8)
        setBorder10(viewName: vPlay, radius: 10)
        setBorder10(viewName: vInner, radius: 10)
        
        btnplayAudio.isHidden = true
        vPlay.isHidden = true
        indicator.isHidden = true
        imgRole.isUserInteractionEnabled = true
        imgRole.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
    check_record_permission()
       
        let role = UserDefaults.standard.string(forKey: Constant.ROLE_MODEL)
        let chal = UserDefaults.standard.string(forKey: Constant.CHALLENGE)
        
        txtChallange.text = chal
        edName.text = role
      
        if UserDefaults.standard.string(forKey: Constant.ROLE_IMAGE) != nil
        {
            let strImageURL =
            UserDefaults.standard.string(forKey: Constant.ROLE_IMAGE)!
          
            if(strImageURL.count>5)
            {
                imageContains = "image"
                let urlYourURL = URL (string:strImageURL )
                imgRole.loadurl(url: urlYourURL!)
               
            }
        }
        
         if UserDefaults.standard.string(forKey: Constant.RECORDING) != nil
        {
            let strImageURL =
            UserDefaults.standard.string(forKey: Constant.RECORDING)!
          
            if(strImageURL.count>5)
            {
               
                let urlYourURL = URL (string:strImageURL )
              audioURL = urlYourURL
                btnplayAudio.isHidden = false
            }
        }
        
        setLanguage()
        
    }
    
    func setLanguage()
    {
        btnReset.setTitle(LocalisationManager.localisedString("reset"), for: .normal)
        btnPlayPause.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
       
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        txtHeading.text = LocalisationManager.localisedString("self_talk_setup")
        txtChal.text = LocalisationManager.localisedString("challenge")
        txtRoleModel.text = LocalisationManager.localisedString("role_model")
        txtPrepar.text = LocalisationManager.localisedString("preapring_game")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnReset.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnplayAudio.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnPlayPause.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        slider.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        record_btn_ref.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        play_btn_ref.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//        .backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
      
        txtChal.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtRoleModel.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtAudioName.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtPrepar.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtTimePlay.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
    }
    
    
    
    @objc func profileCall()
    {
       optionSelection()
    }
    
    func getValues()
    {
     
        let challange = txtChallange.text.trimmingCharacters(in: .whitespaces)
        let role = edName.text!.trimmingCharacters(in: .whitespaces)
        
        if let text = edName.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("role_model"), Message: LocalisationManager.localisedString("enter_role_name_error"))
        }
        else if let text = txtChallange.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("challenge"), Message: LocalisationManager.localisedString("enter_challenge_error"))
        }
        else
        {
            if imageContains.count > 2
            {
                uploadDocument(strName: role, strChallenge:
                challange)
            }
            else if recordingDone == 1
            {
                uploadDocument(strName: role, strChallenge:
                                challange)
            }
            else
            {
                addDataAPI(strName: role, strChallenge:
                            challange)
            }
        }
            
            
    }
    func optionSelection()
    {
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: LocalisationManager.localisedString("camera"), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 1
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: LocalisationManager.localisedString("gallery"), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 2
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
//        pickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
        pickerController.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
//        alert.popoverPresentationController!.sourceView = self.view
//        alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)

        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imageoptionSelected = 1
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary;
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.delegate = self
            pickerController.sourceType = .camera;
            pickerController.cameraDevice = .front
            pickerController.allowsEditing = true
            self.imageoptionSelected = 1
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage {
            //newImage = possibleImage
            print("if works edited")
           
                    imgRole.contentMode = .scaleAspectFit
                    imgRole.image = possibleImage
                  
           
            imageOrg = possibleImage
          //  let data = possibleImage.pngData()
            
        }
         else {
            print("else works")
            return
        }
        dismiss(animated: true, completion: nil)
        if(imageoptionSelected == 2)
        {
            let imageUrl          = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
            let image             = info[UIImagePickerController.InfoKey.editedImage]as! UIImage
            
            let data              = image.jpeg(.medium)
            
            imageContains = localPath!.absoluteString
            
                let  filePath = localPath!
            print(localPath)
            do
            {
                try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
                if let imageData = image.jpeg(.lowest) {
                    print(imageData.count)
                }
            }
            catch
            {
                // Catch exception here and act accordingly
            }
           
              
            
        } else
        {
            print(imageoptionSelected)
            
            let folderName = "updateprofile" + "/"
            let  userFolder = URL.createFolder(folderName: folderName)
            
           
            
                let localPath = userFolder?.appendingPathComponent("image" + ".jpg")
                let image = imageOrg
                let data = image!.jpegData(compressionQuality: 0.5)! as NSData
                data.write(to: localPath!, atomically: true)
                imageContains = folderName
//                imgaeUpdate = 1
                let photoURL = localPath?.absoluteURL
                filePath = photoURL
             
           
        }
        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadDocument(strName : String, strChallenge : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        
        self.btnSave.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()

        let parameters = ["role_model": strName , "challenge" : strChallenge ]
        print(parameters)
        AF.upload(
            multipartFormData: {
                
                multipartFormData in
                if (self.imageContains.count) > 2
                {
                    if ((self.filePath?.hasDirectoryPath) != nil)
                    {
                        multipartFormData.append(self.filePath!, withName: "image" , fileName: "profiler.jpeg", mimeType: "image/jpeg")
                    }
                }
                    
                if self.recordingDone == 1
                {
                    let url = self.getFileUrl()
                    multipartFormData.append(url, withName: "recording" , fileName: "record.mp3", mimeType: "*/*")
                }
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                print(multipartFormData)
            },
            to: Constant.baseURL + Constant.seasonSelfTalkAPI, method: .post, headers: header)
            //    .response { response in
            .responseJSON { (response) in
                let status = response.response?.statusCode
           print(response)
                
                    switch response.result{
                    case .success:
                      
                        if let json = response.data {
                            do{
                                let json = try JSON(data: json)
                           
                                let status = json["status"]
                              
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                
                                if("\(status)" == "1")
                                {
                                    self.btnSave.isEnabled = true
                                    UserDefaults.standard.set("\(json["data"]["role_model"])", forKey: Constant.ROLE_MODEL)
                                    UserDefaults.standard.set("\(json["data"]["image"])", forKey: Constant.ROLE_IMAGE)
                                    UserDefaults.standard.set("\(json["data"]["challenge"])", forKey: Constant.CHALLENGE)
                                    UserDefaults.standard.set("\(json["data"]["recording"])", forKey: Constant.RECORDING)
                                    self.alertSucces(title: LocalisationManager.localisedString("success"), Message: "\(json["message"])")
                                }
                                
                                else
                                {
                                    self.btnSave.isEnabled = true
                                    let message = json["message"]
                                    self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(message)")
                                    self.indicator.stopAnimating()
                                    self.indicator.isHidden = true
                                }
                            }
                            catch{
                                self.btnSave.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                print("JSON Error", error)
                                //    self.alertUI(title: "Invalid json", Message: "\(error)")
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        self.btnSave.isEnabled = true
                    // self.alertUI(title: "Invalid faliure", Message: "\(error)")
                    }
                
            }
    }
    
    func addDataAPI(strName : String, strChallenge : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]

        let parameters = ["role_model": strName , "challenge" : strChallenge ]
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.seasonSelfTalkAPI, method: .post, param: parameters,header: header, viewController: self) { (json) in
         print(json)
            
            if("\(json["status"])" == "1")
            {
                UserDefaults.standard.set("\(json["data"]["role_model"])", forKey: Constant.ROLE_MODEL)
                UserDefaults.standard.set("\(json["data"]["image"])", forKey: Constant.ROLE_IMAGE)
                UserDefaults.standard.set("\(json["data"]["challenge"])", forKey: Constant.CHALLENGE)
                UserDefaults.standard.set("\(json["data"]["recording"])", forKey: Constant.RECORDING)
//                UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)
//                UserDefaults.standard.set(self.selectedSports, forKey: Constant.SPORTS)

                self.alertSucces(title:  Constant.SUCCESS, Message:  "\(json["message"])")
               
            }
            else
            {
                self.alertFailure(title: StringConstant.FAILED, Message: "\(json["message"])")
            }
           
        }
     
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
                alertFailure(title: Constant.FAILED, Message: error.localizedDescription)
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
            alertFailure(title: Constant.FAILED, Message: "Recording Failed")
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
            recordingDone = 1
        }
        
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
        play_btn_ref.setTitle("Play", for: .normal)
        isPlaying = false
    }
    

    func play(url:URL)
    {
        let playerItem = AVPlayerItem(url: url)
            btnPlayPause.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            isPlaying = true
            self.player = try AVPlayer(playerItem:playerItem)
//            player!.volume = 1.0
            player!.play()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
               
//                player = AVPlayer(playerItem: playerItem)

                player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                    if self.player!.currentItem?.status == .readyToPlay {
                        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                        self.slider.value = Float ( time )
                        self.slider.minimumValue = 0

                        let duration : CMTime = playerItem.asset.duration
                        let seconds : Float64 = CMTimeGetSeconds(duration)

                        self.slider.maximumValue = Float(seconds)
//                        self.txtAudioName.text = self.secondsToHoursMinutesSeconds(seconds: seconds)

                        self.txtTimePlay.text = self.secondsToHoursMinutesSeconds(seconds: Double( self.slider.value ))
                    }
                }

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (String) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        let sec = 60 * secf
     return  String(format: "%02i:%02i:%02i", Int(hr), Int(min), Int(sec))
       // return ("\(Int(hr)):\(Int(min)):\(Int())")
    }
    

}
