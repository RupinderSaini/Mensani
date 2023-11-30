//
//  SelfTalkController.swift
//  Mensani
//
//  Created by apple on 31/05/23.
//
import AVFoundation
import Alamofire
import SwiftyJSON
import UIKit

class SelfTalkController: UIViewController , UITableViewDelegate, UITableViewDataSource ,  AVAudioRecorderDelegate, AVAudioPlayerDelegate , refreshAudioSelfVisual, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func refreshList() {
        if(self.currentReachabilityStatus != .notReachable)
        {
       selfAPICALL()
        }
        else
        {
            self.alertInternet()
        }
      
    }
    var arrOfAudio : [DatumSelf] = []
    var flag = "0"
    
    var player : AVPlayer!
    @IBOutlet weak var txtNoData: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnAdd: UIImageView!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
   
    @IBOutlet weak var slidetOutlet: UISlider!
    @IBOutlet weak var vRecord: UIView!
    @IBOutlet weak var vInner: UIView!
    @IBOutlet weak var viewPlayMain: UIView!
    @IBOutlet weak var txtAudioName: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
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
    //pause.circle
    @IBOutlet weak var txtPlayTime: UILabel!
    
    @IBOutlet weak var btnReset: UIButton!
    @IBAction func btnReset(_ sender: Any) {
        player.seek(to: .zero)
        btnPlayPause.setImage(UIImage(systemName: "pause.circle"), for: .normal)
        isPlaying = true
        player.play()
    }
    @IBAction func btnCancel(_ sender: Any) {
        player.pause()
        txtPlayTime.text = "00:00:00"
        txtAudioName.text = ""
        vInner.isHidden = true
        viewPlayMain.isHidden = true

       
    }
    var isPlaying = false
    
        override func viewDidLoad() {
            super.viewDidLoad()
 
            let nib2 = SelfTalkCell.nib
            tableview.register(nib2, forCellReuseIdentifier:SelfTalkCell.identifier)
            viewPlayMain.alpha = 0.3
            setBorder10(viewName: vInner, radius: 10)
            
            setBorder10(viewName: btnReset, radius: 10)
           
            setBorder10(viewName: vRecord, radius: 10)
            flag = "\(UserDefaults.standard.string(forKey: Constant.VIEW_SELECTED) ?? "0")"
            vInner.isHidden = true
            viewPlayMain.isHidden = true
//            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
            tableview.delegate = self
            tableview.dataSource = self
            txtNoData.isHidden = true
          
            
            btnAdd.isUserInteractionEnabled = true
            btnAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
            
            let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
            btnAdd.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
            btnReset.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
            btnPlayPause.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
          
            txtNoData.text = LocalisationManager.localisedString("self_talk_empty")
            txtAudioName.text = LocalisationManager.localisedString("audio_name")
            btnReset.setTitle(LocalisationManager.localisedString("reset"), for: .normal)
            btnPlayPause.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
            
            if(self.currentReachabilityStatus != .notReachable)
            {
           selfAPICALL()
            }
            else
            {
                self.alertInternet()
            }
        }
    
        @objc func addCall()
        {
            alertUISelect()
        }

//        func audioCall()
//        {
////            let flag = "\(UserDefaults.standard.string(forKey: Constant.SELF_ADD)!)"
////
////            if flag == "0"
////            {
//                lazy var sheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "rec") as! RecordController
//                sheetVC.callFrom = 0
//                sheetVC.delegate = self
//                if #available(iOS 15.0, *) {
//                    if let sheet = sheetVC.sheetPresentationController{
//                        sheet.detents = [.medium() ]
//                    }
//                } else {
//                    // Fallback on earlier versions
//                }
//                self.present(sheetVC, animated: true, completion: nil)
////            }
////            else
////            {
////                alertFailure(title: StringConstant.CONFIRMATION, Message: StringConstant.SELF_ADD_MESSAGE)
////            }
//        }
   
   //https://stackoverflow.com/questions/34563329/how-to-play-mp3-audio-from-url-in-ios-swift
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("table relaod")
          
            return arrOfAudio.count
        }

    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: SelfTalkCell.identifier, for: indexPath) as! SelfTalkCell
            cell2.selectionStyle = .none
            cell2.txtName.text = arrOfAudio[indexPath.row].audioName
            cell2.btnDelete.tag = indexPath.row
            cell2.btnDelete.addTarget(self, action: #selector(acceptOrder(_:)), for: .touchUpInside)
            if arrOfAudio[indexPath.row].type == 1
            {
                cell2.imgPlay.image = UIImage(systemName: "play.circle")
            }
            else
            {
                
            }
            return cell2
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrOfAudio[indexPath.row].type == 0
//        if arrOfAudio[indexPath.row].recording.lowercased().hasSuffix(".mp3") || arrOfAudio[indexPath.row].recording.lowercased().hasSuffix(".m4a")
        {
            let urlString = arrOfAudio[indexPath.row].recording.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            //        let str = "https://argaamplus.s3.amazonaws.com/eb2fa654-bcf9-41de-829c-4d47c5648352.mp3"
            let urlYourURL = URL (string:  urlString!)
            play(url: urlYourURL!)
            slidetOutlet.value = 0
            txtAudioName.text = arrOfAudio[indexPath.row].audioName
            viewPlayMain.isHidden = false
            vInner.isHidden = false
        }
        else
        {
            let secondViewController = mainStoryboard.instantiateViewController(withIdentifier: "play") as! PlayVideoController
          
            secondViewController.strURL  = arrOfAudio[indexPath.row].recording.description
            secondViewController.strName = arrOfAudio[indexPath.row].audioName
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    
    @objc func acceptOrder(_ sender: UIButton) {
        let position = sender.tag
        if(self.currentReachabilityStatus != .notReachable)
        {
            alertUIDelete(stId: arrOfAudio[position].id.description, position: position)
        }
        else
        {
            self.alertInternet()
        }
       
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
                        self.slidetOutlet.value = Float ( time )
                        self.slidetOutlet.minimumValue = 0

                        let duration : CMTime = playerItem.asset.duration
                        let seconds : Float64 = CMTimeGetSeconds(duration)

                        self.slidetOutlet.maximumValue = Float(seconds)
//                        self.txtAudioName.text = self.secondsToHoursMinutesSeconds(seconds: seconds)

                        self.txtPlayTime.text = self.secondsToHoursMinutesSeconds(seconds: Double( self.slidetOutlet.value ))
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
    
    func selfAPICALL( )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "type"]
        var APIname = ""
        if flag == "0"
        {
            APIname = Constant.viewVisualAPI
        }
        else
        {
            APIname = Constant.viewSelfAPI
        }
        APIManager.shared.requestService(withURL: APIname, method: .post, param: param , header: header, viewController: self) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SelfListResponse.self, from: data)
                    self.arrOfAudio = model.data
                   
                    if (self.arrOfAudio.count > 0)
                    {
                        self.txtNoData.isHidden = true
                        self.tableview.isHidden = false

                        self.tableview.reloadData()
                        UserDefaults.standard.setValue(self.arrOfAudio[0].flag, forKey: Constant.SELF_ADD)
                       
                    }
                    else
                    {
                        self.tableview.isHidden = true

                        self.txtNoData.isHidden = false
                    }
                }
                catch {
                    print("exception")
                }
            }
           
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
    func deleteProductAPI(stId : String, position : Int)
    {
        let strToken =  UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let headers: HTTPHeaders =
            [Constant.ACCEPT : Constant.APP_JSON,Constant.AUTHORIZATION: strToken]
        var APIname = ""
        var param : [String : String]
        if flag == "0"
        {
            APIname = Constant.deleteVisualAPI
            param = ["visualization_id": stId]
        }
        else
        {
            APIname = Constant.deleteAudioAPI
            param = ["selftalk_id": stId]
        }
       
        print(param)
        APIManager.shared.requestService(withURL: APIname, method: .post, param: param,header:  headers , viewController: self) { (json) in
         print(json)
            if("\(json["status"])" == "1")
            {
                
                self.arrOfAudio.remove(at: position)
                if (self.arrOfAudio.count > 0)
                {
                    self.txtNoData.isHidden = true
                    self.tableview.isHidden = false
                    self.tableview.reloadData()
                }
                else
                {
                    self.txtNoData.isHidden = false
                    self.tableview.isHidden = true
                }
                 
            }
            
            else{
                
                self.txtNoData.isHidden = false
            }
          
            UserDefaults.standard.setValue("\(json["flag"])", forKey: Constant.SELF_ADD)
           
        }
    }
    
    func alertUIDelete(stId : String, position : Int) -> Void
    {
        
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("del_subs"), message: LocalisationManager.localisedString("string_confirm_txt"), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("no"), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("yes"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.deleteProductAPI(stId: stId, position: position)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    private let pickerController = UIImagePickerController()
    func videoCall()
    {
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = ["public.movie"]
//        pickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
        pickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            pickerController.delegate = self
//            pickerController.sourceType = .photoLibrary;
//            pickerController.allowsEditing = true
           
            self.present(pickerController, animated: true, completion: nil)
        }
    }


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.mediaURL] as? URL  {
            //newImage = possibleImage
            print("if works edited")
           
            print(possibleImage)
            let imageUrl          = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
           print(localPath)
            
                var movieData: Data?
                    do {
                        movieData = try Data(contentsOf: possibleImage, options: Data.ReadingOptions.alwaysMapped)
                    } catch {
                        print("in catch")
                        print(error)
                        movieData = nil
                        return
                    }
            
            
            dismiss(animated: true, completion: nil)
            uploadDocument(url : possibleImage , type:  "1")
//            imageOrg = possibleImage
          //  let data = possibleImage.pngData()
            
        }
         else {
            print("else works")
            return
        }
        dismiss(animated: true, completion: nil)

        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func alertUISelect() -> Void
    {
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("sel_upload_type"), message: "", preferredStyle: UIAlertController.Style.alert)
    
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("video"), style: .default, handler: { (action: UIAlertAction!) in
            self.videoCall()
            
        }))
    
    
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("audio"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.audioCall()
//                self.deleteProductAPI(stId: stId, position: position)
            }
            else
            {
                self.alertInternet()
            }
    
        }))
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.dismiss(animated: true, completion: nil)
//                self.audioCall()
//                self.deleteProductAPI(stId: stId, position: position)
            }
            else
            {
                self.alertInternet()
            }
    
        }))
    
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func audioCall()
     {
         
       
//            if flag == "0"
//            {
             lazy var sheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "rec") as! RecordController
         if flag == "0"
         {
             sheetVC.callFrom = 1
         }
         else
         {
             sheetVC.callFrom = 0
         }
             sheetVC.delegate = self
             if #available(iOS 15.0, *) {
                 if let sheet = sheetVC.sheetPresentationController{
                     sheet.detents = [.medium() ]
                 }
             } else {
                 // Fallback on earlier versions
             }
             self.present(sheetVC, animated: true, completion: nil)
//            }
//            else
//            {
//                alertFailure(title: StringConstant.CONFIRMATION, Message: StringConstant.VIS_ADD_MESSAGE)
//            }
     }
    
    func uploadDocument(url : URL , type : String)
    {
        
//        let url = getFileUrl()
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        
//        indicator.isHidden = false
//        indicator.startAnimating()
      
        var ApiName = ""
       
        if flag == "0"
        {
            ApiName = Constant.recordVisualAPI
             
        }
        else
        {
            ApiName = Constant.recordSelfAPI
            
        }
        let parameters = ["audio_name": "video.mov"  , "type" : type]
        print(parameters)
        AF.upload(
            multipartFormData: { multipartFormData in
                     multipartFormData.append(url, withName: "recording" , fileName: "video.mov", mimeType: "*/*")
               
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                print(multipartFormData)
            },
            to: Constant.baseURL + ApiName, method: .post, headers: header)
            //    .response { response in
        .responseJSON { (response) in
            print(response)
            
            switch response.result{
            case .success:
                print("Validation Successful)")
                
                if let json = response.data {
                    do
                    {
                        let data = try JSON(data: json)
                   
                        let status = data["status"]
                      
//                        self.indicator.stopAnimating()
//                        self.indicator.isHidden = true
                        
                        if("\(status)" == "1")
                        {
//                            self.delegate!.refreshList()
                            self.dismiss(animated: true)
                        }
                        else
                        {
                            let message = data["message"]
                            self.alertFailure(title: LocalisationManager.localisedString("failed") , Message: "\(message)")
//                            self.indicator.stopAnimating()
//                            self.indicator.isHidden = true
                        }
                    }
                    catch
                    {
//                        self.indicator.stopAnimating()
//                        self.indicator.isHidden = true
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
    

