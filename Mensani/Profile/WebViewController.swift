//
//  WebViewController.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//
import WebKit
import UIKit

class WebViewController: UIViewController , WKUIDelegate , WKNavigationDelegate{
    var callFrom = 0
    var url = ""
    
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        webView.navigationDelegate = self
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.scrollView.showsHorizontalScrollIndicator = false

        if callFrom == 0
        {
            let lang = LocalData.getLanguage(LocalData.language)
            let myURL = URL(string: Constant.baseURL + "privacy_policy" + "/\(lang)")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
        
        
        else
        {
            print(url)
            let myURL = URL(string:url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
//    override func loadView() {
//          let webConfiguration = WKWebViewConfiguration()
//          webView = WKWebView(frame: .zero, configuration: webConfiguration)
//          webView.uiDelegate = self
//          view = webView
//       }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("finish to load")
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            if(url.lowercased().contains("success") )
            {
                alertSucces(title: LocalisationManager.localisedString("payment"), Message: LocalisationManager.localisedString("payment_done"))
                _ = navigationController?.popViewController(animated: true)
//                placeOrderAPI()
            }
        }
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            if(url.lowercased().contains("failed") )
            {
                let paymentResponse = url.split(separator: "/")
                let size = paymentResponse.count - 1
                let status = paymentResponse[size]
                print(status)
              
                let str = status.removingPercentEncoding!
                self.alertSucces(title: "Payment Failed!!!", Message: "\(str)")
            }
        }
        
//        if let url = webView.url?.absoluteString{
//            print("url = \(url)")
//
//            if(url.contains("hnbCyberSourceResponse") )
//
//            {
//                print("hnbCyberSourceResponsehnbCyberSourceResponsehnb")
//                print("entered in if hnbCyberSourceResponse")
//                self.alertFailure(title: "Wait for a moment", Message: "Please wait while your payment is in processing")
//                self.indicator.isHidden = false
//            }
//        }
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            if(url.lowercased().contains("checkout") )
            {
              
            }
        }
        
      
    }
}
