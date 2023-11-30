//
//  SupportCell.swift
//  Mensani
//
//  Created by apple on 02/06/23.
//

import UIKit

class SupportCell: UITableViewCell {

    @IBOutlet weak var txtPro: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var viewUi: UIView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var btnViews: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorderCell(viewName: txtPro, radius: 10)
        setBorderCell(viewName: viewUi, radius: 10)
        txtPro.layer.cornerRadius = 10
        imgThumbnail.layer.borderWidth = 1
        imgThumbnail.layer.masksToBounds = false
        imgThumbnail.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgThumbnail.layer.cornerRadius = imgThumbnail.frame.height/2
        imgThumbnail.clipsToBounds = true
        btnViews.layer.cornerRadius = 8
        txtPro.isHidden = true
        
    }
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        setBorderCell(viewName: txtPro, radius: 10)
    }
    
}
