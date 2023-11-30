//
//  LaunchController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 22/11/23.
//

import UIKit

class LaunchController: UIViewController {

    @IBOutlet weak var imgLaunch: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgLaunch.image = UIImage(systemName: "lock")
    }
    

 

}
