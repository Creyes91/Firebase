//
//  HomeViewController.swift
//  Firebase
//
//  Created by Tardes on 14/1/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var mail: String!
   
    
    //MARK: Register options
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var genderOptions: UISegmentedControl!
    @IBOutlet weak var aceptButton: UIButton!
    
    //MARK: Login Data
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var valPass: UITextField!
    
    //MARK: MENU OPTIONS
    
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var FAButton: UIButton!
    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        //fetchData()
        emailText.text = mail
        createButton(for: passText)
        createButton(for: valPass)
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    func createButton (for textField : UITextField)
    {
        let button = UIButton()
        
        button.setTitle("  ", for: .normal)
               button.setTitleColor(.blue, for: .normal)
               button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        //button.configuration?.imagePadding = 16
               button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
               button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       
        
     

               // Asignar el botón al rightView del TextField
        textField.rightView = button
        textField.rightViewMode = .always
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let textField = sender.superview as? UITextField else { return }
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let icon = self.passText.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: icon), for: .normal)
        }
    
    
    
    @IBAction func HiddeMenu(_ sender: Any) {
        if menuVisible {
                   // Ocultar el menú
                   UIView.animate(withDuration: 0.3) {
                       self.MenuView.frame.origin.x = -420
                   }
               } else {
                   // Mostrar el menú
                   UIView.animate(withDuration: 0.3) {
                       self.MenuView.frame.origin.x = 0
                   }
               }
        
        menuVisible = !menuVisible
    }
    

    
    @IBAction func LogOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
     //   performSegue(withIdentifier: "toMain", sender: LogOutButton)
    }
    
  
    @IBAction func saveUser(_ sender: Any) {
        if let email = self.emailText.text, let pass = self.passText.text
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
    
    func showMessage(type: String, message: String)
    {
        let alert = UIAlertController(title: type, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
