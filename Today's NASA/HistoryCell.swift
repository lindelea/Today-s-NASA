//
//  HistoryCell.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/11.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import WebKit

class HistoryCell: UITableViewCell {
    
    static let identity = "HistoryCell"

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(photo: Photo) {
        let subviews = self.photo.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        if photo.mediaType == "video" {
            let webview = WKWebView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.photo.frame.width,
                                                  height: self.photo.frame.height))
            webview.load(URLRequest(url: photo.url))
            self.photo.addSubview(webview)
        } else {
            photo.fetchImage { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                }
            }
        }
        
        self.date.text = self.dateFormat(dateString: photo.date)
        self.title.text = photo.title
    }
    
    func dateFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        return dateFormatter.string(from: date)
    }
}
