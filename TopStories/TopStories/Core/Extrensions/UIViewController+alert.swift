//
//  UIViewController+alert.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import UIKit

extension UIViewController {
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

