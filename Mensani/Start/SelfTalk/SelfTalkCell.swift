//
//  SelfTalkCell.swift
//  Mensani
//
//  Created by apple on 31/05/23.
//

import UIKit

class SelfTalkCell: UITableViewCell {
    @IBOutlet weak var imgPlay: UIImageView!
    
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorderCell(viewName: viewUi, radius: 10)
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        imgPlay.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
