//
//  ImageViewerVC.swift
//  agsChat
//
//  Created by MAcBook on 29/06/22.
//

import UIKit

class ImageViewerVC: UIViewController {
    
    var strImageName : String?
    var imgSelectedImage : UIImage?
    
    @IBOutlet weak var imgDisplayImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if strImageName != "" {
            NetworkManager.sharedInstance.getData(from: URL(string: strImageName!)!) { data, response, err in
                if err == nil {
                    DispatchQueue.main.async {
                        self.imgDisplayImg.image = UIImage(data: data!)
                    }
                }
            }
            imgDisplayImg.image = UIImage(named: strImageName!)
        } else {
            imgDisplayImg.image = imgSelectedImage
        }
        
    }
    
}
