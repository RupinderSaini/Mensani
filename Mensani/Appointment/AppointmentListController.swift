//
//  PerfromImproveController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 22/11/23.
//

import UIKit
import LZViewPager

class AppointmentListController: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource  {
    
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
        txtSupport.text = LocalisationManager.localisedString("appointment")
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        txtSupport.text = LocalisationManager.localisedString("appointment")
        let vc1 =   storyboard?.instantiateViewController(withIdentifier: "book")
        vc1!.title = LocalisationManager.localisedString("upcoming")
//        let vc2 =  storyboard?.instantiateViewController(withIdentifier: "men")
//        vc2!.title = LocalisationManager.localisedString("back")
        let vc3 =  storyboard?.instantiateViewController(withIdentifier: "bookpast")
        vc3!.title = LocalisationManager.localisedString("Past")
       
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
        let button = UIButton()
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
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
    
//    func didSelectButton(at index: Int) {
//        print(index)
//        if index == 0
//        {
//
//        }
//        else
//        {
//            txtSupport.text = LocalisationManager.localisedString("post_imp")
//        }
//    }
}
