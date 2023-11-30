//
//  ImprovementCell.swift
//  Mensani
//
//  Created by apple on 15/06/23.
//

import UIKit
protocol DeleteImproveAction {
    func deleteCell( id : Int)
}

class ImprovementCell: UITableViewCell {
    
  
        var delegate : DeleteImproveAction?
        
        var idImprovement = 0
        @IBAction func btnDelete(_ sender: Any) {
            delegate?.deleteCell( id: idImprovement)
        }
        @IBOutlet weak var vTxt: UIView!
        @IBOutlet weak var txtCount: UILabel!
        @IBOutlet weak var txtPerfor: UILabel!
        @IBOutlet weak var btnDelete: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
            setBorderCell(viewName: vTxt, radius: 10)
            txtCount.layer.cornerRadius = txtCount.frame.width/2
            txtCount.layer.masksToBounds = true
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
        var cellViewModel2: DatumImprovement? {
            didSet {
                idImprovement = cellViewModel2?.id ?? 0
                txtPerfor.text = cellViewModel2?.improvement
                
                //               .text = cellViewModel?.age
            }
        }
        
        class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
        
    
    
}
