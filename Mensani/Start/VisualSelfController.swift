//
//  VisualSelfController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 16/11/23.
//

import UIKit
import LZViewPager

class VisualSelfController: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource  {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSupport: UILabel!
    @IBOutlet weak var viewPager: LZViewPager!
    private var subControllers:[UIViewController] = []
    var flag = 0
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
       
        let vc3 =  storyboard?.instantiateViewController(withIdentifier: "self")
        
        if flag == 0
        {
            txtSupport.text =  LocalisationManager.localisedString("visulization")
            vc3!.title = LocalisationManager.localisedString("visulization")
        }
        else
        {
            txtSupport.text =   LocalisationManager.localisedString("self_talk")
            vc3!.title = LocalisationManager.localisedString("self")
        }
        
      
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
       
        let vc1 =   storyboard?.instantiateViewController(withIdentifier: "visual")
        vc1!.title = LocalisationManager.localisedString("admin")
//        let vc2 =  storyboard?.instantiateViewController(withIdentifier: "men")
//        vc2!.title = LocalisationManager.localisedString("back")
       
     
    
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
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundImage(UIImage.imageWithColor(color: UIColor.black), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: hexStringToUIColor(hex: color ?? "#fff456")), for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
}

