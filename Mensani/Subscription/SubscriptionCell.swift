//
//  SubscriptionCell.swift
//  Mensani
//
//  Created by apple on 28/06/23.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var btnDuration: UIButton!
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var btnSubscribed: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       setBorderCell(viewName: viewUi, radius: 10)
       setBorderCell(viewName: btnDuration, radius: 5)
       setBorderCell(viewName: btnCancel, radius: 5)
        setBorderCell(viewName: btnSubscribed, radius: 10)
        btnSubscribed.isHidden = true
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnDuration.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtPrice.textColor = .white
        btnCancel.setTitle(LocalisationManager.localisedString("cancel"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
}
