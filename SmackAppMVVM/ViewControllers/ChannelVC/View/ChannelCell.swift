//
//  ChannelCell.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    var viewModel = channelCellViewModel()
    
    @IBOutlet weak var channelNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.setCellInstance(cell: self)
        setObsever()
    }
    // MARK: - setSelected(_ selected: Bool, animated: Bool)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewModel.cellSelection(isSelected: selected)
    }
    
    // MARK: - setObsever()
    func setObsever(){
        viewModel.channelTitle.observe = { title in
            self.channelNameLbl.text = title
        }
    }
}



