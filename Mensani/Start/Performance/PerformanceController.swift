//
//  PerformanceController.swift
//  Mensani
//
//  Created by apple on 25/05/23.
//

import UIKit

class PerformanceController: UIViewController ,  UITableViewDelegate, UITableViewDataSource, DeleteAction , ImproveMentDelegate{
    func sendResponse(handleString: String?)
    {
       
        if handleString == "1"
        {
            
            viewAdd.isHidden = true
            txtImprove.text = edPerformace.text
            UserDefaults.standard.set(edPerformace.text, forKey: Constant.IMPROVEMENT)
            edPerformace.text = ""
        }
    }
    
   
    @IBOutlet weak var txtAddPerImp: UILabel!
    @IBOutlet weak var txtTwo: UILabel!
    @IBOutlet weak var txtPerfor: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    //    @IBOutlet weak var txt3: UILabel!
    @IBOutlet weak var txtImprove: UILabel!
    @IBOutlet weak var txt1: UILabel!
//    @IBOutlet weak var vp3: UIView!
//    @IBOutlet weak var vp2: UIView!
    @IBOutlet weak var vp1: UIView!
    @IBOutlet weak var txtFour: UILabel!
    func deleteCell(id: Int) {
        print(id)
        viewModel.deleteAPICALL(id: id, controller: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewAdd.isHidden = true
        
        edPerformace.text = ""
        if viewModel.notificationViewModels.count == 0
        {
            return 3
        }
        else
        {
            return viewModel.notificationViewModels.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PerformanceCell.identifier, for: indexPath) as? PerformanceCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.delegate = self
//        cell.btnDelete.
        cell.txtCount.text = (indexPath.row + 1 ).description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position =  (indexPath.row + 1)
        addFrom = 0
//        position = viewModel.getCellViewModel(at: indexPath).id
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        viewAdd.isHidden = false
    }
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnSave(_ sender: Any) {
        if addFrom == 0
        {
            viewModel.sendValues(performance: edPerformace.text.trimmingCharacters(in: .whitespaces), sequence: position , controller: self)
        }
        else
        {
            viewModelI.delegate = self
            
                viewModelI.sendValues(performance: edPerformace.text.trimmingCharacters(in: .whitespaces), controller: self)
        }
    }
    @IBAction func btnCancel(_ sender: Any) {
        viewAdd.isHidden = true
    }
    @IBOutlet weak var edPerformace: UITextView!
    @IBOutlet weak var viewAdd: UIView!
//    @IBOutlet weak var imgAdd: UIImageView!
    
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnImprove(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "improve") as? ImprovementController
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtNoData: UILabel!
    
    var isAdd = 0
    var position = 0
    var addFrom = 0 // 0 = performance 1= improvement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAdd.isHidden = true
        tableView.register(PerformanceCell.nib, forCellReuseIdentifier: PerformanceCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tblHeight.constant = tableView.contentSize.height
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        txtFour.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtTwo.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtAddPerImp.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        btnSave.backgroundColor =  hexStringToUIColor(hex: color ?? "#fff456")
        edPerformace.tintColor =  hexStringToUIColor(hex: color ?? "#fff456")
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        txtFour.text = LocalisationManager.localisedString("did_well")
        txtTwo.text = LocalisationManager.localisedString("imp_two")
        
        
        txt1.layer.cornerRadius = txt1.frame.width/2
        txt1.layer.masksToBounds = true
        vp1.isUserInteractionEnabled = true
        vp1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
        
        setupToHideKeyboardOnTapOnView()
        setBorder10(viewName: btnSave, radius: 20)
        setBorder10(viewName: btnCancel, radius: 20)
        setBorder10(viewName: edPerformace, radius: 10)
        setBorder10(viewName: vp1, radius: 10)

        txtNoData.isHidden = true
        let improve = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT)
        txtImprove.text = improve
        
//        txtNoData.textColor = .black
        initViewModel()
    }
    
    lazy var viewModel = {
          PerformanceVM()
       }()
    
    
    lazy var viewModelI = {
          ImproveVM()
       }()
    
    func initViewModel()
    {
           viewModel.notiAPICALL(controller: self)
           viewModel.reloadTableView = { [weak self] in
               DispatchQueue.main.async {
                   self?.tableView.reloadData()
                   self?.tblHeight.constant = (self?.tableView.contentSize.height)! + 32

               }
           }
       }
    
    @objc func addCall()
    {
//       let isAdd = UserDefaults.standard.string(forKey: Constant.PERFORMACE_ADD)
//        if isAdd == "0"
//        {
        addFrom = 1
            viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("enter_imp")
//        }
//        else
//        {
//            alertFailure(title: StringConstant.CONFIRMATION, Message: StringConstant.PER_ADD_MESSAGE)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        print("view appear")
    }

}
