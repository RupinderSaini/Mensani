//
//  SportsController.swift
//  Mensani
//
//  Created by apple on 20/06/23.
//

import UIKit
import Alamofire

class SportsController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnBack: UIButton!
    var delegate : sportsDelegate?
    
    @IBOutlet weak var txtSports: UILabel!
    var selectedSports = ""
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    var arrOfSports : [DatumSports] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSports.text = LocalisationManager.localisedString("sports")
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        tableView.register(SportsCell.nib, forCellReuseIdentifier: SportsCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
//        tableView.separatorColor = .white
        self.tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        if(self.currentReachabilityStatus != .notReachable)
        {
        sportsAPICall()
}
        else
        {
            self.alertInternet()
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfSports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SportsCell.identifier, for: indexPath) as? SportsCell else { fatalError("xib does not exists") }
        cell.txtSportsName.text = arrOfSports[indexPath.row].sport
        if selectedSports == arrOfSports[indexPath.row].sport
        {
            cell.viewUi.layer.borderColor = #colorLiteral(red: 0.9770143628, green: 0.7121481895, blue: 0, alpha: 1)
            cell.viewUi.layer.borderWidth = 3
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print( arrOfSports[indexPath.row].sport)
       
        delegate?.selectedSportId(sports: arrOfSports[indexPath.row].sport ,  id: arrOfSports[indexPath.row].id.description)
        navigationController?.popViewController(animated: true)
    }
   
    func sportsAPICall()
    {
//        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : "apiToken"]
        
//        let strAPIToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let parameters = ["api" : "apiToken"]
        
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.sportsAPI, method: .post, param: parameters, header: header, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SportsListResponse.self, from: data)
                    self.arrOfSports = model.data
                    self.tableView.reloadData()
                }
                catch {
                    print("exception")
                }
            
            }
            else
            {
               
                self.alertFailure(title: Constant.FAILED, Message: "\(json["message"])")
            }
           
        }
    }
    
    
}
protocol sportsDelegate
{
    func selectedSportId(sports : String , id : String)
}
