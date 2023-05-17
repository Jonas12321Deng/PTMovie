//
//  PopupManager.swift
//  PTMovie
//
//  Created by Jons on 2023/5/17.
//

import UIKit

class PopupManager: NSObject {
    static let shared = PopupManager()
    
    private override init() {
        
    }
    
    func showAlert(on ViewController: UIViewController?, with titleStr: String, with messageStr: String) {
        if let ViewController = ViewController {
            let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            ViewController.present(alert, animated: true, completion: nil)
        }
    }
}
