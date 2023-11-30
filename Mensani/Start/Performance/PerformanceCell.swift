//
//  PerformanceCell.swift
//  Mensani
//
//  Created by apple on 25/05/23.
//

import UIKit

protocol DeleteAction {
    func deleteCell( id : Int)
}

class PerformanceCell: UITableViewCell  {
    var delegate : DeleteAction?
    var id = 0
    var idImprovement = 0
    @IBAction func btnDelete(_ sender: Any) {
        delegate?.deleteCell( id: id)
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
   
    
    var cellViewModel: DatumPerformance? {
           didSet {
               id = cellViewModel?.id ?? 0
               txtCount.text = cellViewModel?.performance
               txtPerfor.text = cellViewModel?.performance
               btnDelete.tag = cellViewModel?.id ?? 0
//               .text = cellViewModel?.age
           }
       }
    var cellViewModel2: DatumImprovement? {
           didSet {
               idImprovement = cellViewModel2?.id ?? 0
               txtPerfor.text = cellViewModel2?.improvement
               btnDelete.tag = cellViewModel?.id ?? 0
//               .text = cellViewModel?.age
           }
       }
    
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

