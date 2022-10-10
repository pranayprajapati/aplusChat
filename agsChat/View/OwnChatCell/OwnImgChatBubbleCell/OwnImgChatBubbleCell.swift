//
//  OwnImgChatBubbleCell.swift
//  agsChat
//
//  Created by MAcBook on 28/06/22.
//

import UIKit

class OwnImgChatBubbleCell: UITableViewCell {

    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    
    private var imageRequest: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewImg.layer.cornerRadius = 5
        imgVideo.isHidden = true
    }

    func configure(_ msgType : String,_ image : String,_ data : String) {
        if msgType == "video" {
            img.image = UIImage(named: "default")
            imgVideo.isHidden = false
            imgVideo.image = UIImage(named: "Play")
            
            let imageData = try? Data(contentsOf: URL(string: data)!)
            if let imageData = imageData {
                img.image = UIImage(data: imageData)
            }
        }
        else if msgType == "image" {
            img.image = UIImage(named: "default")
            img.image = UIImage(contentsOfFile: image)
            if image != "" {
                imageRequest = NetworkManager.sharedInstance.getData(from: URL(string: image)!) { data, resp, err in
                    guard let data = data, err == nil else {
                        print("Error in download from url")
                        return
                    }
                    DispatchQueue.main.async {
                        let dataImg : UIImage = UIImage(data: data)!
                        
                        /*if (dataImg.size.height) > (dataImg.size.width) {
                            self.img.widthAnchor.constraint(equalTo: self.img.heightAnchor, multiplier: 0.5)
                        } else if (dataImg.size.height) < (dataImg.size.width) {
                            self.img.widthAnchor.constraint(equalTo: self.img.heightAnchor, multiplier: 2)
                        }   //  */
                        self.img.image = dataImg
                        //self.imgProfile.contentMode = .scaleAspectFit
                        //self.imgProfile.contentMode = .scaleAspectFill
                    }
                }
            }   //  */
        }
    }
    
    override func prepareForReuse() {
        imgVideo.isHidden = true
        // Reset Thumbnail Image View
        img.image = UIImage(named: "default")
        // Cancel Image Request
        imageRequest?.cancel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
