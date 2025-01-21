//
//  InitViewController.swift
//  Firebase
//
//  Created by Tardes on 21/1/25.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class InitViewController: UIViewController {

    @IBOutlet weak var EmailPasswordButton: UIButton!
    @IBOutlet weak var GoogleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoogleButton(_ sender: UIButton) {
        googleSignin()
    }
    
    @objc func googleSignin() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential){ result , error in
                
                
                guard error == nil
                    
                else {
                    return}
            }
        }
        
        
    }
    
  
}
