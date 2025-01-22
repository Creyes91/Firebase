//
//  showMessage.swift
//  Firebase
//
//  Created by Tardes on 22/1/25.
//

import Foundation
import UIKit

extension UIAlertController{
    
    func showMessage(type: String, message: String)
    {
        let alert = UIAlertController(title: type, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
