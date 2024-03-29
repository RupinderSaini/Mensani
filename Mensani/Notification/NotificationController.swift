//
//  NotificationController.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import UIKit
import LZViewPager

class NotificationController: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource  {
 
    @IBOutlet weak var txtNoti: UILabel!
    
    @IBOutlet weak var viewPager: LZViewPager!
    @IBOutlet weak var stackBtn: UIStackView!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSeason: UIButton!
    @IBAction func btnSeason(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "season") as? SeasonController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnStart(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start") as? StartController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func btnSupport(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "support") as? SupportController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
  
   
    @IBOutlet weak var viewBtn: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder10(viewName: btnStart, radius: 15)
        setBorder10(viewName: btnSeason, radius: 15)
        setBorder10(viewName: btnSupport, radius: 15)
       
       
        stackBtn.layer.cornerRadius=20
        stackBtn.clipsToBounds=true
//        viewBottom(viewBtn: viewBtn)
        
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.hostController = self
        txtNoti.text =    LocalisationManager.localisedString("notifications")
        btnStart.setTitle(LocalisationManager.localisedString("event"), for: .normal)
        btnSeason.setTitle(LocalisationManager.localisedString("season"), for: .normal)
        btnSupport.setTitle(LocalisationManager.localisedString("support"), for: .normal)
      
        let vc1 =   storyboard?.instantiateViewController(withIdentifier: "new")
        vc1!.title = LocalisationManager.localisedString("new1")
        let vc2 =  storyboard?.instantiateViewController(withIdentifier: "all")
        vc2!.title = LocalisationManager.localisedString("all")
       
        subControllers.append(vc1!)
        subControllers.append(vc2!)
       
        viewPager.reload()
    }
    func shouldEnableSwipeable() -> Bool {
        return false
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
//    func backgroundColorForHeader() -> UIColor
//    {
//        return UIColor.black
//    }
    
   
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
   
    
//    func widthForButton(at index: Int) -> CGFloat
//    {
//        return 100
//    }
    
    private var subControllers:[UIViewController] = []
      

     func buttonsAligment()  -> ButtonsAlignment{
        return .center
    }
}
