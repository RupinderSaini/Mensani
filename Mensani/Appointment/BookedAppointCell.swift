//
//  BookedAppointCell.swift
//  Mensani
//
//  Created by apple on 12/07/23.
//

import UIKit

class BookedAppointCell: UITableViewCell {

    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var txtName: UILabel!
//    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    setBorderCell(viewName: viewUi, radius: 10)
        setBorderCell(viewName: btnDate, radius: 10)
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnDate.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        
//        imgProfile.layer.borderWidth = 1
//        imgProfile.layer.masksToBounds = false
//        imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
//        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
}
