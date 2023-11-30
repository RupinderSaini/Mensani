//
//  AppointmentCell.swift
//  Mensani
//
//  Created by apple on 11/07/23.
//

import UIKit

class AppointmentCell: UICollectionViewCell {

    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setBorderCell(viewName: viewUi, radius: 5)
       
    }
    
//    override var isSelected: Bool {
//           didSet {
//               viewUi.backgroundColor = isSelected ? #colorLiteral(red: 0.9770143628, green: 0.7121481895, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//               txtTime.textColor = .black
////               viewUi.layer.borderColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//           }
//       }
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
