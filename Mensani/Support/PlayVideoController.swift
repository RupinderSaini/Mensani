//
//  PlayVideoController.swift
//  Mensani
//
//  Created by apple on 30/06/23.
//
import AVFoundation
import AVKit
import UIKit
import Alamofire


class PlayVideoController: UIViewController {
    var strURL = ""
    var strType = ""
    var comeFrom = 0 // 1 = event , 2 = support
    @IBOutlet weak var vMain: UIView!
    var strName = ""
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = strName
        print(strURL)
        let urlYourURL = URL (string:  strURL)
        
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        let player = AVPlayer(url: urlYourURL!)
        player.volume = 1.0
        let playerController = AVPlayerViewController()
        
        playerController.view.layoutMargins.bottom = 100
        playerController.player = player
        self.addChild(playerController)
        
        self.vMain.addSubview(playerController.view)
        
        let playerLayer = AVPlayerLayer(player: player)
        self.vMain.layer.addSublayer(playerLayer)
        
        print(player.currentItem!.asset.duration)
       
        
        player.play()
        
        if comeFrom == 1
        {
            NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    @objc func finishVideo()
       {
               print("Video Finished")
           pointAPICall()
       }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func pointAPICall()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
      
        let strAPIToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let parameters = ["type": strType]
        
        print("parameters",parameters)
//        APIManager.shared.requestService(withURL: Constant.pointsAddAPI, method: .post, param: parameters, header: header, viewController: self) { (json) in
//         print(json)
//
//        }
        
        AF.request(Constant.baseURL + Constant.pointsAddAPI, method: .post, parameters: parameters ,headers: header )
            .responseJSON { response in
             
                print(response)
            }
    }
}
