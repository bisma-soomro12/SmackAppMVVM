//
//  MessageCell.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 07/02/2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var viewModel = MessageCellViewModel()
    
    // outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.setCellInstance(cell: self)
        setObserver()
    }
    
    // MARK: - setObserver()
    func setObserver(){
        viewModel.userName.observe = { name in
            self.UserNameLbl.text = name
        }
        viewModel.message.observe = { msg in
            self.messageLbl.text = msg
        }
        viewModel.timeStamp.observe = { date in
            self.timeStampLbl.text = date
        }
        viewModel.imageName.observe = { image in
            self.userImage.image = UIImage(named: image)
        }
        viewModel.background.observe = { color in
            self.userImage.backgroundColor = UserDataService.instance.returnUIColor(components: color)
        }
    }
}
