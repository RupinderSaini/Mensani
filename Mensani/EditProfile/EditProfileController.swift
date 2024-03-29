//
//  EditProfileController.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import DropDown

class EditProfileController: UIViewController , sportsDelegate,UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
    func selectedSportId(sports: String, id: String) {
        print("delagate cll")
        selectedSports = sports
        txtSport.text = selectedSports
    }
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var txtTeamHead: UILabel!
    @IBOutlet weak var vTeam: UIView!
    @IBOutlet weak var txtTeam: UILabel!
    @IBOutlet weak var txtEditProfile: UILabel!
    @IBOutlet weak var txtSports: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        getValues()
    }
    
    @IBOutlet weak var txtSport: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var vSports: UIView!
    @IBOutlet weak var edEmail: UITextField!
    @IBOutlet weak var edName: UITextField!
    var selectedSports = ""
    var strName = ""
    var strEmail = ""
    var imageContains = ""
    var filePath : URL? = nil
    var imageOrg : UIImage? = nil
    var imageoptionSelected = 0
    var sportIDTeam = ""
    var arrOfTeam : [DatumTeams] = []
    private let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
       
        edEmail.text = UserDefaults.standard.string(forKey: Constant.EMAIL)
        edName.text = UserDefaults.standard.string(forKey: Constant.NAME)
        txtSport.text = UserDefaults.standard.string(forKey: Constant.SPORTS)
        sportIDTeam = UserDefaults.standard.string(forKey: Constant.SPORTS_ID) ?? "1"
        txtTeam.text = UserDefaults.standard.string(forKey: Constant.TEAM)
        
        if UserDefaults.standard.string(forKey: Constant.IMAGE) != nil
        {
            let strImageURL =
            UserDefaults.standard.string(forKey: Constant.IMAGE)!
            print("imageurl")
            print(strImageURL)
            if(strImageURL.count>2)
            {
                print("inside")
                //                imageContains = "image"
                
                let urlYourURL = URL (string:strImageURL )
                imgProfile.loadurl(url: urlYourURL!)
            }
        }
       
        
    }
    
    
    func initViews()
    {
        indicator.isHidden = true
        edEmail.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        edName.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtSport.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtTeam.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        setBorder10(viewName: btnUpdate, radius: 23)
        setBorder10(viewName: indicator, radius: 10)
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        //        vSports.isUserInteractionEnabled = true
        //        vSports.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sportsCall)))
        
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
        
      
    
        txtEditProfile.text = LocalisationManager.localisedString("edit_pro")
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnUpdate.setTitle(LocalisationManager.localisedString("update"), for: .normal)
        txtName.text = LocalisationManager.localisedString("name")
        txtEmail.text = LocalisationManager.localisedString("Email")
        txtSports.text = LocalisationManager.localisedString("sports")
        txtTeamHead.text = LocalisationManager.localisedString("team")
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnUpdate.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtName.textColor = .white
        txtEmail.textColor = .white
        txtSports.textColor = .white
        txtTeamHead.textColor = .white
        edName.tintColor = .white
        indicator.backgroundColor = .white
        
        if UserDefaults.standard.string(forKey: Constant.TEAM_TYPE)?.lowercased() == "private"
        {
           
        }
        else
        {
            vTeam.isUserInteractionEnabled = true
            vTeam.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.teamCall)))
            teamAPICall()
        }
    }
    
    @objc func sportsCall()
    {
        
        performSegue(withIdentifier: "sports", sender: nil)
        
    }
    
    @objc func teamCall()
    {
        
        dropDown2.show()
        
    }
    
    @objc func profileCall()
    {
        optionSelection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let secondViewController = segue.destination as! SportsController
        secondViewController.selectedSports = (txtSport.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        secondViewController.delegate = self
        
    }
    func getValues()
    {
        if let text = edName.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("name"), Message: LocalisationManager.localisedString("enter_name_error"))
        }
        
        else if let text = edEmail.text, text.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("Email"), Message: LocalisationManager.localisedString("enter_email_error"))
        }
        else if edEmail.text?.trimmingCharacters(in: .whitespaces).isValidateEmail()==false
        {
            alertFailure(title: LocalisationManager.localisedString("Email"), Message: LocalisationManager.localisedString("enter_valid_email"))
            
        }
        else{
            strEmail = edEmail.text!.trimmingCharacters(in: .whitespaces)
            strName = edName.text!.trimmingCharacters(in: .whitespaces)
            
            if(currentReachabilityStatus != .notReachable)
            {
                
                if (imageContains.count < 2)
                {
                    profileUpdateAPI()
                }
                else
                {
                    uploadDocument()
                }
            }
            else{
                alertFailure(title: StringConstant.NO_INTERNET, Message: StringConstant.NO_INTER)
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
            
            imgProfile.contentMode = .scaleAspectFit
            imgProfile.image = possibleImage
            
            
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
        
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadDocument()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        
        self.btnUpdate.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        
        let sports = txtSport.text
        let lang = LocalData.getLanguage(LocalData.language)
        let parameters = ["name": strName , "sports_name" : sports! , "email" : strEmail , "lang" : lang , "team_name" : team]
        print(parameters)
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(self.filePath!, withName: "image" , fileName: "profiler.jpeg", mimeType: "image/jpeg")
                
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                print(multipartFormData)
            },
            to: Constant.baseURL + Constant.profileUpdateApi, method: .post, headers: header)
        //    .response { response in
        .responseJSON { (response) in
            let status = response.response?.statusCode
            
            switch response.result{
            case .success:
                print("Validation Successful)")
                
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        
                        let status = data["status"]
                        
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        
                        if("\(status)" == "1")
                        {
                            self.btnUpdate.isEnabled = true
                            UserDefaults.standard.set("\(data["data"]["image"])", forKey:Constant.IMAGE)
                            UserDefaults.standard.set(self.strName, forKey: Constant.NAME)
                            UserDefaults.standard.set(sports!, forKey: Constant.SPORTS)
                            UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)
                            UserDefaults.standard.set( self.txtTeam.text, forKey: Constant.TEAM)
                            
                            self.alertSucces(title: Constant.SUCCESS, Message: "Your profile updated successfully ")
                        }
                        
                        else
                        {
                            self.btnUpdate.isEnabled = true
                            let message = data["message"]
                            self.alertFailure(title: StringConstant.FAILED, Message: "\(message)")
                            self.indicator.stopAnimating()
                            self.indicator.isHidden = true
                        }
                    }
                    catch{
                        self.btnUpdate.isEnabled = true
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        print("JSON Error", error)
                        //    self.alertUI(title: "Invalid json", Message: "\(error)")
                    }
                    
                }
            case .failure(let error):
                print(error)
                self.btnUpdate.isEnabled = true
                // self.alertUI(title: "Invalid faliure", Message: "\(error)")
            }
            
        }
    }
    
    func profileUpdateAPI()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        let sports = txtSport.text
        let lang = LocalData.getLanguage(LocalData.language)
        let parameters = ["name": strName , "sports_name" : sports! , "email" : strEmail , "lang" : lang , "team_name" : team]
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.profileUpdateApi, method: .post, param: parameters,header: header, viewController: self) { (json) in
            print(json)
            
            if("\(json["status"])" == "1")
            {
                UserDefaults.standard.set(self.strName, forKey: Constant.NAME)
                UserDefaults.standard.set(self.strEmail, forKey: Constant.EMAIL)
                UserDefaults.standard.set(sports!, forKey: Constant.SPORTS)
                UserDefaults.standard.set( self.txtTeam.text, forKey: Constant.TEAM)

                self.alertSucces(title:  Constant.SUCCESS, Message:  "\(json["message"])")
                
            }
            else
            {
                self.alertFailure(title: StringConstant.FAILED, Message: "\(json["message"])")
            }
            
        }
        
    }
    
    func teamAPICall()
    {
        let param = ["sport_id" : sportIDTeam]
        print(sportIDTeam)
        AF.request(Constant.baseURL + Constant.teamAPI, method: .post, parameters: param ,encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let json):
                    print(json)
                    
                    DispatchQueue.main.async {
                        
                        do
                        {
                            let model = try JSONDecoder().decode(TeamsResponse.self, from: response.data!)
                            self.arrOfTeam = model.data
                            var arrOfName : [String] = []
                            for name in self.arrOfTeam
                            {
                                arrOfName.append(name.teamName)
                            }
                            self.dropDown2.dataSource = arrOfName
                            self.dropDownTeam()
                        }
                        catch {
                            print("exception")
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    let dropDown2 = DropDown()
    var team = ""
    
    func dropDownTeam()
    {
        print("func call")
        dropDown2.anchorView = txtTeam
        dropDown2.direction = .any
        
        dropDown2.layer.cornerRadius = 10
        
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            txtTeam.text = "\(item)"
            team = "\(item)"
            //            setYellow(string: LocalisationManager.localisedString("teams"), textField: txtTeam)
            
            //            education = "\(item)"
            //            dropDown.dismissMode = .onTap
            
        }
    }
    
}
