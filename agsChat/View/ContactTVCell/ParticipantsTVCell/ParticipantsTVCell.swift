//
//  ParticipantsTVCell.swift
//  agsChat
//
//  Created by MAcBook on 10/08/22.
//

import UIKit

class ParticipantsTVCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    private var imageRequest: Cancellable?
    var contectInfoVC: (()->ContectInfoVC)?
    var strUserId : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        lblAdmin.clipsToBounds = true
        lblAdmin.layer.cornerRadius = 7
        btnRemove.layer.cornerRadius = 7
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(_ image : String) {
        imgProfile.image = UIImage(named: "default")
        if image != "" {
            imageRequest = NetworkManager.sharedInstance.getData(from: URL(string: image)!) { data, resp, err in
                guard let data = data, err == nil else {
                    print("Error in download from url")
                    return
                }
                DispatchQueue.main.async {
                    let dataImg : UIImage = UIImage(data: data)!
                    self.imgProfile.image = dataImg
                }
            }
        }   //  */
    }
    
    @IBAction func btnRemoveTap(_ sender: UIButton) {
        self.contectInfoVC?().removeUserTap(strUserId)
    }
    
    override func prepareForReuse() {
        // Reset Thumbnail Image View
        //imgProfile.image = UIImage(named: "default")
        // Cancel Image Request
        imageRequest?.cancel()
    }
}
