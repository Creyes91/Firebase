//
//  AuthViewController.swift
//  Firebase
//
//  Created by Tardes on 13/1/25.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

  
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth"
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func CreateUser(_ sender: Any) {
     
            if let email = mail.text, let pass = password.text
        {
                if email.isEmpty || pass.isEmpty
                {
                    showMessage(type:"Error", message: "Data Empty")
                    
                    return
                    
                }
                
                
                Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                    
                    if let error = error
                    {
                        self.showMessage(type: "Error", message: error.localizedDescription)
                        return
                    }
                    else {
                        self.showMessage(type: "Message", message: "User created successfully")
                        return
                        
                    }
                }
            }
    }
    
    
        @IBAction func LogUser(_ sender: Any) {
            
            if let email = mail.text, let pass = password.text
            {
                if email.isEmpty || pass.isEmpty
                {
                    showMessage(type:"Error", message: "Data Empty")
                    
                    return
                    
                }
                
                Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
                    
                    if let error = error
                    {
                        self!.showMessage(type: "Error", message: error.localizedDescription)
                        return
                    }
                    else {
                        self!.showMessage(type: "Message", message: "User Logged succesfully")
                        return
                        
                    }
                    
                }
                
            }
            
          
        
        
        
    }
    
    func showMessage(type: String, message: String)
    {
        let alert = UIAlertController(title: type, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
  
    

}

