//
//  UITableViewCell+Identifier.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }

    static func nib() -> UINib {
        return UINib.init(nibName: "\(self)", bundle: nil)
    }
}

extension UITableView {

    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.nib(), forCellReuseIdentifier: T.identifier)
    }
}
