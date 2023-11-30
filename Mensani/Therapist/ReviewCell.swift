//
//  ReviewCell.swift
//  Mensani
//
//  Created by apple on 07/07/23.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var txtReview: UILabel!
    
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var txtrating: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        txtrating.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
       setBorderCell(viewName: viewUi, radius: 10)
        
        imgProfile.layer.borderWidth = 1
              imgProfile.layer.masksToBounds = false
              imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
              imgProfile.layer.cornerRadius = imgProfile.frame.height/2
              imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
}
