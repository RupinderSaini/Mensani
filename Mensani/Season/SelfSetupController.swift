//
//  SelfSetupController.swift
//  Mensani
//
//  Created by apple on 22/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation


class SelfSetupController: UIViewController,UIImagePickerControllerDelegate,
                           UINavigationControllerDelegate,  AVAudioRecorderDelegate, AVAudioPlayerDelegate {

 
  
    @IBAction func btnClear(_ sender: Any) {
        edName.text = ""
        txtChallange.text = ""
        txtTraits.text = ""
        imgRole.image = nil
    }
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var txtUploadImage: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var txtRoleImage: UILabel!

    @IBOutlet weak var txtChal: UILabel!
   
    @IBOutlet weak var txtHeading: UILabel!
 
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func btnSave(_ sender: Any) {
        if(currentReachabilityStatus != .notReachable)
        {
            getValues()
        }
        else{
            alertFailure(title: StringConstant.NO_INTERNET, Message: StringConstant.NO_INTER)
        }
    }
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtTraits: UITextView!
    @IBOutlet weak var txtChallange: UITextView!
    @IBOutlet weak var imgRole: UIImageView!
    @IBOutlet weak var edName: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    var imageContains = ""
    var filePath : URL? = nil
    var imageOrg : UIImage? = nil
    var imageoptionSelected = 0
    private let pickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder10(viewName: txtChallange, radius: 10)
     
        setBorder10(viewName: btnSave, radius: 20)
        
        setBorder10(viewName: edName, radius: 10)
        setBorder10(viewName: indicator, radius: 10)
        setBorder10(viewName: txtTraits, radius: 10)
       
        indicator.isHidden = true
        imgRole.isUserInteractionEnabled = true
        imgRole.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
       
        let role = UserDefaults.standard.string(forKey: Constant.ROLE_MODEL)
        let chal = UserDefaults.standard.string(forKey: Constant.CHALLENGE)
        let chal2 = UserDefaults.standard.string(forKey: Constant.RECORDING)
        
        txtChallange.text = chal
        txtTraits.text = chal2
        edName.text = role
        btnClear.isHidden = true
        if edName.text!.count > 1
        {
            btnClear.isHidden = false
        }
      
        if UserDefaults.standard.string(forKey: Constant.ROLE_IMAGE) != nil
        {
            let strImageURL =
            UserDefaults.standard.string(forKey: Constant.ROLE_IMAGE)!
          
            if(strImageURL.count>5)
            {
                imageContains = "image"
                let urlYourURL = URL (string:strImageURL )
                imgRole.loadurl(url: urlYourURL!)
                imgPhoto.isHidden = true
                txtUploadImage.isHidden = true
            }
        }
        
         
        
        setLanguage()
        
    }
    
//    func setLanguage()
//    {
//
//        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
//        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
//        txtHeading.text = LocalisationManager.localisedString("self_talk_setup")
//        txtChal.text = LocalisationManager.localisedString("challenge")
//        txtUploadImage.text = LocalisationManager.localisedString("upload_image")
//
//        edName.placeholder = LocalisationManager.localisedString("enter_role_name")
//        txtRoleImage.text = LocalisationManager.localisedString("role_image")
//
//        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
//        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//
//        indicator.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtRoleImage.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//
//        txtChal.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtUploadImage.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        imgPhoto.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//
//        edName.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtChallange.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//    }
    
    func setLanguage()
    {
       
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        txtHeading.text = LocalisationManager.localisedString("self_talk_setup")
        txtChal.text = LocalisationManager.localisedString("challenge")
        txtUploadImage.text = LocalisationManager.localisedString("upload_image")
      
        edName.placeholder = LocalisationManager.localisedString("enter_role_name")
        txtRoleImage.text = LocalisationManager.localisedString("role_image")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
       
        indicator.backgroundColor = .white
        txtRoleImage.textColor = .white
      
        txtChal.textColor = .white
        txtUploadImage.textColor = .white
        imgPhoto.tintColor = .white
        
        edName.tintColor = .white
        txtChallange.tintColor = .white
    }
    
    
    
    @objc func profileCall()
    {
       optionSelection()
    }
    
    func getValues()
    {
     
        let challange = txtChallange.text.trimmingCharacters(in: .whitespaces)
        let traits = txtTraits.text.trimmingCharacters(in: .whitespaces)
        let role = edName.text!.trimmingCharacters(in: .whitespaces)
        
        if let text = edName.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("role_model"), Message: LocalisationManager.localisedString("enter_role_name_error"))
        }
        else if let text = txtTraits.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("role_image"), Message: LocalisationManager.localisedString("enter_trait_error"))
        }
        else if let text = txtChallange.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("challenge"), Message: LocalisationManager.localisedString("enter_challenge_error"))
        }
        else
        {
            if imageContains.count > 2
            {
                uploadDocument(strName: role, strChallenge:
                challange , traits: traits)
            }
            
            else
            {
                addDataAPI(strName: role, strChallenge:
                            challange , traits : traits)
            }
        }
            
            
    }
    func optionSelection()
    {
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: LocalisationManager.localisedString("camera"), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 1
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: LocalisationManager.localisedString("gallery"), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.imageoptionSelected = 2
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
//        pickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
        pickerController.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
//        alert.popoverPresentationController!.sourceView = self.view
//        alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)

        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imageoptionSelected = 1
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary;
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.delegate = self
            pickerController.sourceType = .camera;
            pickerController.cameraDevice = .front
            pickerController.allowsEditing = true
            self.imageoptionSelected = 1
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let possibleImage = info[.editedImage] as? UIImage {
            //newImage = possibleImage
            print("if works edited")
           
                    imgRole.contentMode = .scaleAspectFit
                    imgRole.image = possibleImage
                  
           
            imageOrg = possibleImage
          //  let data = possibleImage.pngData()
            
        }
         else {
            print("else works")
            return
        }
        dismiss(animated: true, completion: nil)
        if(imageoptionSelected == 2)
        {
            let imageUrl          = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
            let image             = info[UIImagePickerController.InfoKey.editedImage]as! UIImage
            
            let data              = image.jpeg(.medium)
            
            imageContains = localPath!.absoluteString
            
                let  filePath = localPath!
            print(localPath)
            do
            {
                try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
                if let imageData = image.jpeg(.lowest) {
                    print(imageData.count)
                }
            }
            catch
            {
                // Catch exception here and act accordingly
            }
           
              
            
        } else
        {
            print(imageoptionSelected)
            
            let folderName = "updateprofile" + "/"
            let  userFolder = URL.createFolder(folderName: folderName)
            
           
            
                let localPath = userFolder?.appendingPathComponent("image" + ".jpg")
                let image = imageOrg
                let data = image!.jpegData(compressionQuality: 0.5)! as NSData
                data.write(to: localPath!, atomically: true)
                imageContains = folderName
//                imgaeUpdate = 1
                let photoURL = localPath?.absoluteURL
                filePath = photoURL
             
           
        }
        imgPhoto.isHidden = true
        txtUploadImage.isHidden = true
        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadDocument(strName : String, strChallenge : String , traits : String)
    {
        imgPhoto.isHidden = true
        txtUploadImage.isHidden = true
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        
        self.btnSave.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()

        let parameters = ["role_model": strName , "challenge" : strChallenge , "role_model_traits" :  traits]
        print(parameters)
        AF.upload(
            multipartFormData: {
                
                multipartFormData in
                if (self.imageContains.count) > 2
                {
                    if ((self.filePath?.hasDirectoryPath) != nil)
                    {
                        multipartFormData.append(self.filePath!, withName: "image" , fileName: "profiler.jpeg", mimeType: "image/jpeg")
                    }
                }
                    
              
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                print(multipartFormData)
            },
            to: Constant.baseURL + Constant.seasonSelfTalkAPI, method: .post, headers: header)
            //    .response { response in
            .responseJSON { (response) in
                let status = response.response?.statusCode
           print(response)
                
                    switch response.result{
                    case .success:
                      
                        if let json = response.data {
                            do{
                                let json = try JSON(data: json)
                           
                                let status = json["status"]
                                self.imgPhoto.isHidden = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                
                                if("\(status)" == "1")
                                {
                                    self.btnSave.isEnabled = true
                                    UserDefaults.standard.set("\(json["data"]["role_model"])", forKey: Constant.ROLE_MODEL)
                                    UserDefaults.standard.set("\(json["data"]["image"])", forKey: Constant.ROLE_IMAGE)
                                    UserDefaults.standard.set("\(json["data"]["challenge"])", forKey: Constant.CHALLENGE)
                                    UserDefaults.standard.set(traits, forKey: Constant.RECORDING)
                                 
                                    self.alertSucces(title: LocalisationManager.localisedString("success"), Message: "\(json["message"])")
                                }
                                
                                else
                                {
                                    self.btnSave.isEnabled = true
                                    let message = json["message"]
                                    self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(message)")
                                    self.indicator.stopAnimating()
                                    self.indicator.isHidden = true
                                }
                            }
                            catch{
                                self.btnSave.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                                print("JSON Error", error)
                                //    self.alertUI(title: "Invalid json", Message: "\(error)")
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        self.btnSave.isEnabled = true
                    // self.alertUI(title: "Invalid faliure", Message: "\(error)")
                    }
                
            }
    }
    
    func addDataAPI(strName : String, strChallenge : String , traits : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]

        let parameters = ["role_model": strName , "challenge" : strChallenge , "role_model_traits" :  traits]
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.seasonSelfTalkAPI, method: .post, param: parameters,header: header, viewController: self) { (json) in
         print(json)
            
            if("\(json["status"])" == "1")
            {
                UserDefaults.standard.set("\(json["data"]["role_model"])", forKey: Constant.ROLE_MODEL)
                UserDefaults.standard.set("\(json["data"]["image"])", forKey: Constant.ROLE_IMAGE)
                UserDefaults.standard.set("\(json["data"]["challenge"])", forKey: Constant.CHALLENGE)
               
                UserDefaults.standard.set(traits, forKey: Constant.RECORDING)
//                UserDefaults.standard.set(self.selectedSports, forKey: Constant.SPORTS)

                self.alertSucces(title:  Constant.SUCCESS, Message:  "\(json["message"])")
               
            }
            else
            {
                self.alertFailure(title: StringConstant.FAILED, Message: "\(json["message"])")
            }
           
        }
     
    }
   
  
    
 

}
