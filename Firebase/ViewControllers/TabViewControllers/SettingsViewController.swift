//
//  SettingsViewController.swift
//  Firebase
//
//  Created by Tardes on 22/1/25.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            SessionManager.shared.clearSession()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    

}
