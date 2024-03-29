//
//  VisualizationController.swift
//  Mensani
//
//  Created by apple on 31/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import Kingfisher


class VisualizationController: UIViewController , UITableViewDelegate, UITableViewDataSource , refreshAudioSelfVisual{
    func refreshList() {
        selfAPICALL()
    }
    
    var arrOfAudio : [DatumVideos] = []
    var flag = "0" //  0 =visual,  1 = self talk
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
    @IBOutlet weak var txtHeading: UILabel!
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
        viewPlayMain.alpha = 0.3
        setBorder10(viewName: vInner, radius: 10)
        
        setBorder10(viewName: btnReset, radius: 10)
        setBorder10(viewName: vRecord, radius: 10)
        vInner.isHidden = true
        viewPlayMain.isHidden = true
        flag = "\(UserDefaults.standard.string(forKey: Constant.VIEW_SELECTED) ?? "0")"
        let nib2 = SupportCell.nib
        tableview.register(nib2, forCellReuseIdentifier:SupportCell.identifier)
        
        //            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
        tableview.delegate = self
        tableview.dataSource = self
        txtNoData.isHidden = true
        txtNoData.text = LocalisationManager.localisedString("visulization_empty")
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        
        btnAdd.isHidden = true
        btnAdd.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        //            btnAdd.isUserInteractionEnabled = true
        //            btnAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
        
        
        selfAPICALL()
    }
    
    //    @objc func addCall()
    //    {
    //        alertUISelect()
    //    }
    
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
    
    
    //https://stackoverflow.com/questions/34563329/how-to-play-mp3-audio-from-url-in-ios-swift
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfAudio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: SupportCell.identifier, for: indexPath) as! SupportCell
        cell2.selectionStyle = .none
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        
        cell2.txtName.text = arrOfAudio[indexPath.row].title
        
        if "\(arrOfAudio[indexPath.row].price)".lowercased().contains("buy")
        {
            let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
            cell2.btnViews.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
            cell2.btnViews.setTitle(LocalisationManager.localisedString("buy"), for: .normal)
        }
        
        else if "\(arrOfAudio[indexPath.row].price)".lowercased().contains("paid")
        {
            //                let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
            //                cell2.btnViews.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
            cell2.btnViews.setTitle("  PRO  ", for: .normal)
            
        }
        else
        {
            cell2.btnViews.isHidden = true
        }
        
        
        let processor = DownsamplingImageProcessor(size:cell2.imgThumbnail.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlYourURL = URL (string: arrOfAudio[indexPath.row].thumbnail.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! )
        //        cell2.imgRest.kf.indicatorType = .activity
        cell2.imgThumbnail.kf.setImage(
            with: urlYourURL,
            //            placeholder: UIImage.init(systemName: "house")?.withTintColor(UIColor.gray) ,
            options: [
                .processor(processor),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { result in
                // Done
            }
        )
        
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = arrOfAudio[indexPath.row].video!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //        let str = "https://argaamplus.s3.amazonaws.com/eb2fa654-bcf9-41de-829c-4d47c5648352.mp3"
        //        let urlYourURL = URL (string:  urlString!)
        //        play(url: urlYourURL!)
        //        slidetOutlet.value = 0
        //        txtAudioName.text = arrOfAudio[indexPath.row].title
        //        viewPlayMain.isHidden = false
        //        vInner.isHidden = false
        var type = ""
        if flag == "0"
        {
            type = "visualization"
        }
        else
        {
            type = "selftalk"
        }
        
        if "\(arrOfAudio[indexPath.row].price)".lowercased().contains("free")
        {
            let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "play") as! PlayVideoController
            pushControllerObj.comeFrom = 1
            pushControllerObj.strType = type
            pushControllerObj.strURL  = arrOfAudio[indexPath.row].video!.description
            pushControllerObj.strName = arrOfAudio[indexPath.row].title.description
            self.navigationController?.pushViewController(pushControllerObj, animated: true)
        }
        else  if "\(arrOfAudio[indexPath.row].price)".lowercased().contains("paid")
        {
            let sid = UserDefaults.standard.string(forKey: Constant.SUBSCRIPTION_ID)
            print(sid)
            if sid! != "0" 
            {
                if arrOfAudio[indexPath.row].video != nil{
                    let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "play") as! PlayVideoController
                    pushControllerObj.comeFrom = 1
                    pushControllerObj.strType = type
                    pushControllerObj.strURL  = arrOfAudio[indexPath.row].video!.description
                    pushControllerObj.strName = arrOfAudio[indexPath.row].title.description
                    self.navigationController?.pushViewController(pushControllerObj, animated: true)
                }
            }
            else
            {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "subsc") as? SubscriptionController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
        else
        {
            let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "web") as! WebViewController
            pushControllerObj.url  = arrOfAudio[indexPath.row].ebookURL.description
            pushControllerObj.callFrom = 1
            self.navigationController?.pushViewController(pushControllerObj, animated: true)
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
        let lang = LocalData.getLanguage(LocalData.language)
        var ApiName = ""
        var param : [String : String]
        if flag == "0"
        {
            
            param = ["category_name": "Visualization Category" , "lang" : lang]
        }
        else
        {
            
            param = ["category_name": "Self-Talk Category" , "lang" : lang]
        }
        print(param)
        APIManager.shared.requestService(withURL: Constant.supportAPI, method: .post, param: param , header: header, viewController: self) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SupportResponse.self, from: data)
                    self.arrOfAudio = model.data
                    if (self.arrOfAudio.count > 0)
                    {
                        self.txtNoData.isHidden = true
                        self.tableview.isHidden = false
                        
                        self.tableview.reloadData()
                        
                    }
                    else
                    {
                        self.tableview.isHidden = true
                        UserDefaults.standard.setValue("0", forKey: Constant.VISUAL_ADD)
                        self.txtNoData.isHidden = false
                    }
                }
                catch {
                    print("exception")
                    print(error)
                }
            }
            
            
            else
            {
                //                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
}
    

