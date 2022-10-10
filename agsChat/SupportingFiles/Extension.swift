//
//  Extension.swift
//  agsChat
//
//  Created by MAcBook on 15/06/22.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Date {
    func toCurrentTimezone() -> Date {
        let timeZoneDifference =
        TimeInterval(TimeZone.current.secondsFromGMT())
        //TimeInterval(TimeZone.current.identifier)
        return self.addingTimeInterval(timeZoneDifference)
        //return self.addingTimeInterval(timeZoneDifference!)
   }
}
