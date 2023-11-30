//
//  HomeController.swift
//  Mensani
//
//  Created by apple on 12/05/23.
//

import UIKit


class HomeController: UITabBarController , UITabBarControllerDelegate{
    var upperLineView: UIView!

    let spacing: CGFloat = 12
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        self.tabBarController?.selectedIndex = 1
//        self.navigationController!.viewControllers.removeAll()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//               self.addTabbarIndicatorView(index: 0, isFirstTime: true)
//           }
//         }
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > idx + 1,
            let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }
        
        imageView.layer.add(bounceAnimation, forKey: nil)
 }
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    

   
}
