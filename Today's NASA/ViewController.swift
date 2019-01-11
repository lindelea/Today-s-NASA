//
//  ViewController.swift
//  Today's NASA
//
//  Created by Jie Wu on 2019/01/10.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var copyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
    }
    
    func loadData() {
        Photo.fetchPhotoInfo { (photo) in
            if let photo = photo {
                DispatchQueue.main.async {
                    self.updateUI(photo: photo)
                }
            }
        }
    }
    
    func updateUI(photo: Photo) {
        photo.fetchImage { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.photo.image = image
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

