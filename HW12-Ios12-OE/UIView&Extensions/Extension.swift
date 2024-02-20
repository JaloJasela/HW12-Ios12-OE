//
//  Extension.swift
//  HW12-Ios12-OE
//
//  Created by JaloJasela on 18.02.2024.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
