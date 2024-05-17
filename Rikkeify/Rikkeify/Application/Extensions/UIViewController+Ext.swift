//
//  UIViewController+Ext.swift
//  Rikkeify
//
//  Created by PearUK on 15/5/24.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    private static let sharedHUD: JGProgressHUD = {
            let hud = JGProgressHUD()
//            hud.animation = JGProgressHUDFadeZoomAnimation()
            return hud
    }()
        
    func showLoading(text: String = "Loading") {
        UIViewController.sharedHUD.textLabel.text = text
        UIViewController.sharedHUD.show(in: self.view)
    }
    
    func hideLoading(after: Double = 0) {
        UIViewController.sharedHUD.dismiss(afterDelay: after)
    }
    
    func showAlert(title: String?, message: String?, showCancel: Bool = false, handler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
            handler?()
            alert.dismiss(animated: true)
        }))
        if showCancel {
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
