//
//  NotificationCell.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var viewUi: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            txtDate.text = nil
            txtDescription.text = nil
            txtTitle.text = nil
        }
    
    var cellViewModel: NotificationCellViewModel? {
           didSet {
               txtTitle.text = cellViewModel?.title
               txtDescription.text = cellViewModel?.description
               txtDate.text = cellViewModel?.date
//               .text = cellViewModel?.age
           }
       }
    
}

struct NotificationCellViewModel {
    var title: String
    var date: String
    var description: String
    var id: String
}
