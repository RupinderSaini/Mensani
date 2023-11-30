//
//  LoginSignUpHome.swift
//  Mensani
//
//  Created by apple on 04/05/23.
//

import UIKit
import LZViewPager
class LoginSignUpHome: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource {

 
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.addBottomBorderWithColor(color: .yellow, width: 0.5)
    
                button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                return button
    }
    
    func widthForButton(at index: Int) -> CGFloat
    {
        return 100
    }
    
    func backgroundColorForHeader() -> UIColor
    {
        return UIColor.black
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func colorForIndicator(at index: Int) -> UIColor
    {
        return #colorLiteral(red: 0.9770143628, green: 0.7121481895, blue: 0, alpha: 1)
    }
   
    @IBOutlet weak var viewPages: LZViewPager!
    private var subControllers:[UIViewController] = []
       override func viewDidLoad() {
           super.viewDidLoad()
           viewPages.dataSource = self
           viewPages.delegate = self
           viewPages.hostController = self
         
           let vc1 =   storyboard?.instantiateViewController(withIdentifier: "login")
           vc1!.title = LocalisationManager.localisedString("login")
           let vc2 =  storyboard?.instantiateViewController(withIdentifier: "sign")
           vc2!.title = LocalisationManager.localisedString("sign_up")
          
           subControllers.append(vc1!)
           subControllers.append(vc2!)
          
           viewPages.reload()
       }

    

}
