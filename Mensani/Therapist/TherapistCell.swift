//
//  TherapistCell.swift
//  Mensani
//
//  Created by apple on 06/07/23.
//

import UIKit

class TherapistCell: UITableViewCell {

    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var txt2: UILabel!
    @IBOutlet weak var txt1: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgThearpist: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
       
//        btnVideo.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        setBorderCell(viewName: viewUi, radius: 10)
        imgThearpist.layer.borderWidth = 1
        imgThearpist.layer.masksToBounds = false
        imgThearpist.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgThearpist.layer.cornerRadius = imgThearpist.frame.height/2
        imgThearpist.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
