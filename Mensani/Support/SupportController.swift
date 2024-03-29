//
//  SupportController.swift
//  Mensani
//
//  Created by apple on 02/06/23.
//

import UIKit
import LZViewPager

class SupportController: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource  {
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSupport: UILabel!
    @IBOutlet weak var viewPager: LZViewPager!
    private var subControllers:[UIViewController] = []
    
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
      
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        txtSupport.text = LocalisationManager.localisedString("support")
        let vc1 =   storyboard?.instantiateViewController(withIdentifier: "edu")
        vc1!.title = LocalisationManager.localisedString("videos")
//        let vc2 =  storyboard?.instantiateViewController(withIdentifier: "men")
//        vc2!.title = LocalisationManager.localisedString("back")
        let vc3 =  storyboard?.instantiateViewController(withIdentifier: "ther")
        vc3!.title = LocalisationManager.localisedString("therapist")
       
        subControllers.append(vc1!)
//        subControllers.append(vc2!)
        subControllers.append(vc3!)
       
        viewPager.reload()
        
        viewPager.backgroundColor = .black
        
        
    }
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }

    func button(at index: Int) -> UIButton {
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        
//        let button = UIButton()
//                button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = .black
////        button.tintColor = .red
//                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//                return button
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.black), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: hexStringToUIColor(hex: color ?? "#fff456")), for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.setTitleColor(UIColor.white, for: .selected)
        return button
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    func buttonsAligment() -> ButtonsAlignment
    {
        return .center
    }
//    func shouldShowIndicator() -> Bool {
//        return false
//    }
}


