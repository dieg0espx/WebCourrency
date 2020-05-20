//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Diego Espinosa on 2020-05-19.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        
       // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        super.viewDidLoad()
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
//        photoInfoController.fetchPhotoInfo { (photoInfo) in
//            guard let photoInfo = photoInfo else { return }
//            DispatchQueue.main.async {
//                self.title = photoInfo.title
//                self.descriptionLabel.text = photoInfo.description
//                if let copyright = photoInfo.copyright {
//                    self.copyrightLabel.text = "Copyright \(copyright)"
//                } else {
//                    self.copyrightLabel.isHidden = true
//                }
//            }
//        }
        
        photoInfoController.fetchPhotoInfo { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        guard let url = photoInfo.url.withHTTPS() else { return }
        let task = URLSession.shared.dataTask(with: url,
            completionHandler: { (data, response, error) in guard let data = data,
            let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.title = photoInfo.title
                self.imageView.image = image
                self.descriptionLabel.text = photoInfo.description
                if let copyright = photoInfo.copyright {
                    self.copyrightLabel.text = "Copyright \(copyright)"
                } else {
                    self.copyrightLabel.isHidden = true
                }
            }
        })
        task.resume()
    }
}

