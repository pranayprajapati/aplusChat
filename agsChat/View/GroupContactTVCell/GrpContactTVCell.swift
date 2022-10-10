//
//  GrpContactTVCell.swift
//  AgsChat
//
//  Created by MAcBook on 28/05/22.
//

import UIKit

protocol SelectContactDelegate {
    func selectContact(sender : UIButton)
}

class GrpContactTVCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var btnSelectContact: UIButton!
    private var imageRequest: Cancellable?
    
    var selectContactDelegate : SelectContactDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ image : String) {
        imgContact.image = UIImage(named: "default")
        if image != "" {
            imageRequest = NetworkManager.sharedInstance.getData(from: URL(string: image)!) { data, resp, err in
                guard let data = data, err == nil else {
                    print("Error in download from url")
                    return
                }
                DispatchQueue.main.async {
                    let dataImg : UIImage = UIImage(data: data)!
                    self.imgContact.image = dataImg
                }
            }
        }   //  */
    }
    
    @IBAction func btnSelectContactTap(_ sender: UIButton) {
        selectContactDelegate?.selectContact(sender: sender)
    }
    
    override func prepareForReuse() {
        // Reset Thumbnail Image View
        //imgProfile.image = UIImage(named: "default")
        // Cancel Image Request
        imageRequest?.cancel()
    }
}
