//
//  AppointmentController.swift
//  Mensani
//
//  Created by apple on 11/07/23.
//

import UIKit
import FSCalendar
import Alamofire

class AppointmentController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , FSCalendarDelegate, FSCalendarDataSource  {
   
    @IBOutlet weak var txtHeading: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSave(_ sender: Any) {
        if  self.alotTime.count > 2
        {
            alertUIPayment()
        }
        else
        {
            alertFailure(title:LocalisationManager.localisedString("time"), Message: LocalisationManager.localisedString("time_empty"))
        }
    }
    @IBOutlet weak var btnSave: UIButton!
    var arrOfAppointment : [TimeSlot] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendar : FSCalendar!
    var strId = ""
    var alotTime = ""
    var strAmount = ""
    var strDate = ""
    var strAppointmentId = ""
    
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellWithReuseIdentifier: AppointmentCell.identifier)
        collectionView.clipsToBounds = true
        
        txtHeading.text = LocalisationManager.localisedString("appointment")
        
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("next"), for: .normal)
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        
    setBorder10(viewName: btnSave, radius: 10)
    setBorder10(viewName: calendar, radius: 10)
        
        calendar.delegate = self
        calendar.dataSource = self
        
    let date = minimumDate(for: calendar)
        print(date)
//        strDate = date.description
        
        appointAPICALL()
        
    }
   
    var selectedIndex = Int ()
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: Date())
        strDate = result
           return Date()
    }
     
    //Set maximum Date
    func maximumDate(for calendar: FSCalendar) -> Date {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "YYYY-MM-dd"
          return dateFormatter.date(from: "2050-01-01") ?? Date()
    }
    // This delegate call when date is DeSelected
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
           print("exact")
        strDate = result
        appointAPICALL()
           print(result)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppointmentCell.identifier, for: indexPath) as! AppointmentCell
        cell.txtTime.text = arrOfAppointment[indexPath.row].slotStartTime + " - " + arrOfAppointment[indexPath.row].slotEndTime
        if selectedIndex == indexPath.row
        {
//            let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
           
            cell.viewUi.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.viewUi.isUserInteractionEnabled = true
        }
        else
        {
            cell.viewUi.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewUi.isUserInteractionEnabled = true
        }
        
        if arrOfAppointment[indexPath.row].booking == 1
        {
            cell.viewUi.backgroundColor =  #colorLiteral(red: 0.8686254621, green: 0.1189405546, blue: 0.06527762115, alpha: 1)
            cell.viewUi.isUserInteractionEnabled = false
            cell.contentView.isUserInteractionEnabled = false
            
        }

//        cell.txtTime.text = arrOfAppointment[indexPath.row]?.slotStartTime
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfAppointment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        strAppointmentId = arrOfAppointment[indexPath.row].appointmentsID.description
        alotTime = arrOfAppointment[indexPath.row].slotStartTime + "/" + arrOfAppointment[indexPath.row].slotEndTime
        alotTime = alotTime.replacingOccurrences(of: ":", with: "%3A")
        selectedIndex = indexPath.row
        collectionView.reloadData()
//        callWebView()
        //https://phpstack-102119-3423473.cloudwaysapps.com/appointment_payment/user_id/price/start_time_appointment/end_time_appointment/date/therapist_id/appointment_id
    }
    
    //https://phpstack-102119-3874918.cloudwaysapps.com/appointment_payment/35/55.0//2023-11-30/52//es
    func callWebView()
    {
        if(self.currentReachabilityStatus != .notReachable)
        {
           
            let userId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "web") as? WebViewController
            vc?.callFrom = 2
            let lang = LocalData.getLanguage(LocalData.language)
            if let number = Int(self.strAmount.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                self.strAmount = number.description
            }
            vc?.url = "\(Constant.baseURL)appointment_payment/\(userId!)/\(strAmount)/\(alotTime)/\(strDate)/\(strId)/\(strAppointmentId)/\(lang)"
            _ = navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
    }
    
    func appointAPICALL()
    {
        var time = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDateToday = formatter.string(from: Date())
        
        
        print(strDate + "  " + strDateToday)
        if strDateToday.contains(strDate)
        {
             time = getTime()
        }
        else
        {
            time = ""
        }
        
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
  
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["therapist_id": strId , "date" : strDate , "lang" : lang ,"time" : time ]
      
        print(param)
        APIManager.shared.requestService(withURL: Constant.appointmentSlotAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(AppointmentResponse.self, from: data)
//                    print(model.data.timeSlot.)
                    self.arrOfAppointment = model.data.timeSlot
                    if self.arrOfAppointment.count > 0
                    {
                        self.alotTime = self.arrOfAppointment[0].slotStartTime + "/" + self.arrOfAppointment[0].slotEndTime
                        self.alotTime = self.alotTime.replacingOccurrences(of: ":", with: "%3A")
                        self.strAppointmentId = self.arrOfAppointment[0].appointmentsID.description
                    }
//                    for i in 0..<model.data.timeSlot.count
//                    {
//                        self.arrOfAppointment.append(model.data.timeSlot. + ":" + model.data.timeSlot[i]?.slotEndTime)
//                    }
//
                    
                    self.collectionView.reloadData()
//                    self.dismiss(animated: true)
                }
                catch {
                    print("exception")
                    print(error)
                }
            }
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
    
    func getTime() -> String
    {
        // *** Create date ***
        let date = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.hour, .year, .minute], from: date)
        print("All Components : \(components)")

        // *** Get Individual components from date ***
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("\(hour):\(minutes):\(seconds)")
        return "\(hour):\(minutes)"
    }
    func alertUIPayment() -> Void
    {
        
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("appointment"), message: LocalisationManager.localisedString("desc_appoint") + "\(strAmount)", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
      
        let attributedString = NSAttributedString(string: LocalisationManager.localisedString("appointment"), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        
        let attributedString2 = NSAttributedString(string: LocalisationManager.localisedString("desc_appoint") + "\(strAmount)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    
        refreshAlert.setValue(attributedString, forKey: "attributedTitle")
        refreshAlert.setValue(attributedString2, forKey: "attributedMessage")
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("yes"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.callWebView()
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
//        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("change_price"), style: .default, handler: { (action: UIAlertAction!) in
////            self.dismiss(animated: true, completion: nil)
//
//            self.alertNewPrice()
//
//        }))
        
        let cancelAction = UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//        cancelAction.setValue(UIColor.red, forKey: "backgroundColor")
        refreshAlert.addAction(cancelAction)
        present(refreshAlert, animated: true, completion: nil)
    }
   
    func alertNewPrice() {
        
        let alertController = UIAlertController(title: LocalisationManager.localisedString("appointment_fee"), message: LocalisationManager.localisedString("nego_price"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LocalisationManager.localisedString("cancel"), style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: LocalisationManager.localisedString("continue1"), style: .default, handler: {
            alert -> Void in
            
            let edAmount = alertController.textFields![0] as UITextField
            edAmount.autocapitalizationType = .allCharacters
            edAmount.keyboardType = .numberPad
            
            print("firstName \(String(describing: edAmount.text))")
            
            if edAmount.text != "" {
                print("in if")
                self.strAmount = edAmount.text!
                self.callWebView()
            }else{
                self.showToast(message: LocalisationManager.localisedString("nego_price"), font: .systemFont(ofSize: 13.0))

            }
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = LocalisationManager.localisedString("appointment_fee")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
    



