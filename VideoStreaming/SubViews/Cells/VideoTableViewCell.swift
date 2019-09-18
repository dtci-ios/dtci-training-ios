//
//  VideoTableViewCell.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 18/09/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet private weak var videoView: VideoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
