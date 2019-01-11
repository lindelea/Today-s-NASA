//
//  ViewController.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/10.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import WebKit

class HistoryDetailViewController: UIViewController {
    
    var historyPhoto: Photo!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var copyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI(photo: historyPhoto)
    }
    
    func updateUI(photo: Photo) {
        if photo.mediaType == "video" {
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            let webview = WKWebView(frame: CGRect(x: self.photo.frame.origin.x,
                                                  y: self.photo.frame.origin.y,
                                                  width: self.photo.frame.width,
                                                  height: self.photo.frame.height), configuration: config)
            webview.load(URLRequest(url: photo.url.withQueries(["playsinline" : "1"])!))
            self.view.addSubview(webview)
        } else {
            photo.fetchImage { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                }
            }
        }
        self.navigationItem.title = photo.title
        self.content.text = photo.content
        if let copyright = photo.copyright {
            self.copyright.text = "Copyright: \(copyright)"
        } else {
            self.copyright.isHidden = true
        }
    }
}

