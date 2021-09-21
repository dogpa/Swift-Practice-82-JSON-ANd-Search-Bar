//
//  SearchInfoTableViewCell.swift
//  Swift Practice # 82 JSON ANd Search Bar
//
//  Created by Dogpa's MBAir M1 on 2021/9/21.
//

import UIKit

class SearchInfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ablumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
