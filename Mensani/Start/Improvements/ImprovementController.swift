//
//  ImprovementController.swift
//  Mensani
//
//  Created by apple on 25/05/23.
//

import UIKit

class ImprovementController: UIViewController,

    UITableViewDelegate, UITableViewDataSource , DeleteImproveAction {
      
        @IBOutlet weak var btnSave: UIButton!
        @IBOutlet weak var btnCancel: UIButton!
        @IBAction func btnSave(_ sender: Any) {
            viewModel.sendValues(performance: edPerformace.text.trimmingCharacters(in: .whitespaces), controller: self)
        }
        @IBAction func btnCancel(_ sender: Any) {
            viewAdd.isHidden = true
        }
        @IBOutlet weak var edPerformace: UITextView!
        @IBOutlet weak var viewAdd: UIView!
        @IBOutlet weak var txtPerform: UITextView!
        
      
        @IBOutlet weak var imgAdd: UIImageView!
        
        @IBAction func btnBack(_ sender: Any) {
            _ = navigationController?.popViewController(animated: true)
        }
        
        @IBOutlet weak var btnBack: UIButton!
     
        @IBOutlet weak var txtNoData: UILabel!
        
        var isAdd = 0
        override func viewDidLoad() {
            super.viewDidLoad()
        
           
            let improve = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT)
    //        txtImprove.text = improve

            viewAdd.isHidden = true
            imgAdd.isUserInteractionEnabled = true
            imgAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
            txtNoData.isHidden = true
            setupToHideKeyboardOnTapOnView()
            setBorder10(viewName: btnSave, radius: 20)
            setBorder10(viewName: btnCancel, radius: 20)
            setBorder10(viewName: edPerformace, radius: 10)
            
        }
        lazy var viewModel = {
            ImproveVM()
           }()
        
        
        @objc func addCall()
        {
            print( UserDefaults.standard.string(forKey: Constant.IMPROVEMENT_ADD)!)
            let isAdd = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT_ADD)!
             if isAdd == "0"
            {
                viewAdd.isHidden = false
            }
            else
            {
                alertFailure(title: StringConstant.CONFIRMATION, Message: StringConstant.IMP_ADD_MESSAGE)
            }
        }
        
        func deleteCell(id: Int) {
            print(id)
            viewModel.deleteAPICALL(id: id, controller: self)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            viewAdd.isHidden = true
            edPerformace.text = ""
            if viewModel.notificationViewModels.count == 0
            {
                txtNoData.isHidden = false
            }
            else
            {
                txtNoData.isHidden = true
            }
            
            if viewModel.notificationViewModels.count >= 2
            {
                print(viewModel.notificationViewModels.count)
                UserDefaults.standard.setValue("1", forKey: Constant.IMPROVEMENT_ADD)
            }
            else
            {
                print("98765")
                print(viewModel.notificationViewModels.count)
                UserDefaults.standard.setValue("0", forKey: Constant.IMPROVEMENT_ADD)
            }
            return viewModel.notificationViewModels.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImprovementCell.identifier, for: indexPath) as? ImprovementCell else { fatalError("xib does not exists") }
            let cellVM = viewModel.getCellViewModel(at: indexPath)
            cell.cellViewModel2 = cellVM
            cell.delegate = self
    //        cell.btnDelete.
            cell.txtCount.text = (indexPath.row + 1 ).description
            return cell
        }

    }
