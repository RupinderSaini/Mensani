//
//  ViewController.swift
//  Mensani
//
//  Created by apple on 03/05/23.
//

import UIKit
import AVKit
import SystemConfiguration
import SwiftyJSON


class ViewController: UIViewController {
    var isAudioRecordingGranted: Bool!

    @IBOutlet weak var imgSplash: UIImageView!
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtQuote: UILabel!
    @IBOutlet weak var vQuote: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        vQuote.backgroundColor = UIColor(white: 1, alpha: 0.4)
    let a =  UserDefaults.standard.value( forKey: Constant.notificationReceived)
        btnLogin.setTitle(LocalisationManager.localisedString("login"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {       super.viewWillAppear(animated)
        btnLogin.setTitle(LocalisationManager.localisedString("login"), for: .normal) 
        if(currentReachabilityStatus != .notReachable)
        {
         
            if(UserDefaults.standard.string(forKey: Constant.IS_LOGGEDIN) == "1")
            {
                btnLogin.isHidden = true
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "home") as? HomeController
//
//                self.navigationController?.setViewControllers([vc!], animated: true)
                performSegue(withIdentifier: "home", sender: nil)
                }
            else
            {
                btnLogin.isHidden = false
            }
            
        }
        else{
            alertInternetMain()
        }
       
        if UserDefaults.standard.string(forKey: Constant.SPLASH_IMAGE) != nil
        {
            let url = URL(string: (UserDefaults.standard.string(forKey: Constant.SPLASH_IMAGE) ?? ""))
                          
            imgSplash.loadurl(url: url!)
        }
        else
        {
            imgSplash.image = UIImage(named: "splash")
        }
 
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func setBorderCell(viewName : AnyObject , radius : CGFloat)
    {
        viewName.layer.cornerRadius=radius
//        viewName.layer.borderWidth = 0.5
//        viewName.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
   
   
}
extension JSON
{
    func getDataFrom(JSON json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
}

extension UITextField {
    func addPaddingToTextField() {
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
        self.leftView = paddingView;
        self.leftViewMode = .always;
        self.rightView = paddingView;
        self.rightViewMode = .always;

    
       // self.backgroundColor = UIColor.whiteColor
        self.textColor = UIColor.black
    }
    
}

extension UIViewController
{
    func setLanguage(_ code : String) {
        let selectedLangCode = LocalData.getLanguage(LocalData.language)
        print(selectedLangCode)
        if selectedLangCode != code {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            Bundle.setLanguage(code)
            if #available(iOS 13.0, *) {
                if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                }
            }else {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                           delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                }}
        
        }
    }
//    func btnBorder(btn : UIButton)
//    {
//        btn.layer.cornerRadius=15
//        btn.clipsToBounds=true
//        btn.layer.borderWidth = 0.5
//        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//    }
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
     func getVideoFileUrl() -> URL
    {
        let filename = "video.mov"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
   
 
    func setBorder10(viewName : AnyObject , radius : CGFloat)
    {
        viewName.layer.cornerRadius=radius
        viewName.layer.borderWidth = 0.5
        viewName.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func viewBottom(viewBtn : AnyObject)
    {
        viewBtn.layer.cornerRadius = 10
        viewBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewBtn.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewBtn.layer.borderWidth = 0.5
    }
    func showProgressLoader() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 55, height: 55))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        let ViewCenter = self.view.center
        let ViewHeight = self.view.frame.height
        let ScreenHeight = UIScreen.main.bounds.height
        var ScreenCenter = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        if ViewHeight < ScreenHeight {
            ScreenCenter.y -= 10.0
        }
        
        //activityIndicator.center = ViewHeight < ScreenHeight ? ScreenCenter : ViewCenter
        activityIndicator.center = ViewCenter
        activityIndicator.tag = 1000
        activityIndicator.hidesWhenStopped = false
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
                
        activityIndicator.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func hideProgressLoader() {
        let array = self.view.subviews.filter({$0.isKind(of: UIActivityIndicatorView.self)})
        print(array)
        
        for activity in array {
            if let activityIndicator = activity as? UIActivityIndicatorView {
                if activityIndicator.tag == 1000 {
                    activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    activityIndicator.removeFromSuperview()
                }
            }
        }
        if array.count > 0 {
            if let activityIndicator = array[0] as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                activityIndicator.removeFromSuperview()
            }
        }
        if let activityIndicator = self.view.subviews.filter(
            { $0.tag == 1000}).first as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            activityIndicator.removeFromSuperview()
        }
    }
    
    func setRed(string : String , textField : UILabel )
    {
        textField.text = string
        textField.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    func setYellow(string : String , textField : UILabel )
    {
        textField.text = string
        textField.textColor = #colorLiteral(red: 0.9770143628, green: 0.7121481895, blue: 0, alpha: 1)
    }
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    func alertInternetMain() -> Void {
        let alert = UIAlertController(title:  "Internet connection", message:  "It seems your internet connection lost. Please connect and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("ok"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                if(self.currentReachabilityStatus != .notReachable)
                {
                    
              
                }
                else{
                    self.alertInternetMain()
                }
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    var isNetworkConnected: Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    func alertUIUnauthorised() {
        let viewController = UIApplication.shared.windows.first!.rootViewController
        
        let alert = UIAlertController(title: "Unauthorized", message: "It seems you are logged in another device. To access this feature please re-login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("ok"), style: .default, handler: { action in
            switch action.style{
            case .default:
                UserDefaults.standard.set("0", forKey: Constant.IS_LOGGEDIN)
                //                                                viewController!.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        viewController!.present(alert, animated: true, completion: nil)
        
    }
    func alertUISubscribe() -> Void
    {
        
        let refreshAlert = UIAlertController(title: "Pro Video", message: "Subscribe a plan to access the pro videos", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Subscribe", style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "subsc") as? SubscriptionController

                self.navigationController?.pushViewController(vc!, animated: true)
              
//                self.tabBarController?.selectedIndex = 0
//                self.performSegue(withIdentifier: "login", sender: nil)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func alertSucces(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("ok"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                _ = self.navigationController?.popViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertInternet() -> Void {
        let alert = UIAlertController(title: "Internet connection", message: "It seems your internet connection is lost. Please connect and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertUIGuestUser() -> Void {
        let alert = UIAlertController(title: "Guest user", message: "It seems you are logged in as guest user. To access this feature please do login/signup", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("login"), style: .default, handler: { action in
            switch action.style{
            case .default:
//                UserDefaults.standard.setValue("0", forKey: Constant.IS_LOGGEDIN)
                //                UserDefaults.standard.set(nil, forKey: Constant.USERADDRESS)
                //                UserDefaults.standard.set(nil, forKey: Constant.USERLATITUDE)
                //                UserDefaults.standard.set(nil, forKey: Constant.USERADDRESSID)
                //                UserDefaults.standard.set(nil, forKey: Constant.USERLONGITUDE)
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
                //                                            self.tabBarController?.selectedIndex = 0
                //                                            self.performSegue(withIdentifier: "login", sender: nil)
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertFailure(title: String,Message : String) -> Void {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("ok"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertMicrophone() -> Void {
        let alert = UIAlertController(title: StringConstant.PERMISSION, message: StringConstant.PERMISSION_MSG, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                break;
            }}))
        alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
                   UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               }))
        //   alert.setBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
protocol Utilities { }

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}

extension String {
    
    func isValidateEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
             return Data(utf8).htmlToAttributedString
        }
        var htmlToString: String {
            return htmlToAttributedString?.string ?? ""
        }
    
    
}
extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                   
                } catch {
                  
                    return nil
                }
            }
            return folderURL
        }
        return nil
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}


extension UIImageView {
    func loadurl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
