//
//  PlayVideoController.swift
//  Mensani
//
//  Created by apple on 30/06/23.
//
import AVFoundation
import AVKit
import UIKit



class PlayVideoController: UIViewController {
var strURL = ""
    
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
        
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        
       
        let player = AVPlayer(url: urlYourURL!)
            let playerController = AVPlayerViewController()
        
        playerController.view.layoutMargins.bottom = 100
//        playerController.view.clipsToBounds = true
//        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
//
            playerController.player = player
            self.addChild(playerController)

        self.vMain.addSubview(playerController.view)
//        playerController.view.frame = self.vMain.frame
//
//            player.play()
//        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
////        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.vMain.frame
        player.volume = 1.0
      
        self.vMain.layer.addSublayer(playerLayer)
        player.play()
        
        
    }
    


}
