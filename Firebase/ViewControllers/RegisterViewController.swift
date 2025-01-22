//
//  HomeViewController.swift
//  Firebase
//
//  Created by Tardes on 14/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    var mail: String!
   
    
    //MARK: Register options
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var genderOptions: UISegmentedControl!
    @IBOutlet weak var aceptButton: UIButton!
    @IBOutlet weak var adresText: UITextField!
    @IBOutlet weak var PhoneNumberText: UITextField!
    
    
    //MARK: Login Data
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var valPass: UITextField!
    
    //MARK: MENU OPTIONS
    

    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.setHidesBackButton(true, animated: false)
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
    
    
    
   

    
  
    
  
    @IBAction func saveUser(_ sender: Any) {
     
        if  validateForm()
        {
            let email = emailText.text!
            let pass = passText.text!
            let VerifyPass = valPass.text
            
            if pass == VerifyPass{
                Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                if let error = error
                {
                    self.showMessage(type: "Error", message: error.localizedDescription)
                    return
                }
                else {
                    self.showMessage(type: "Message", message: "User created successfully")
                    self.createUser()
                    return
                    
                }
            }
        }else
            {
            self.showMessage(type: "Error", message: "The password mismatch")
        }
        }
    }
    
    private func createUser()
    {
        let id = Auth.auth().currentUser!.uid
        let userName = emailText.text!
        let name = nameText.text!
        let lastName = lastNameText.text!
        let address = adresText.text!
        let phoneNum = PhoneNumberText.text!
        let birthDate = birthDate.date
        let gender = switch genderOptions.selectedSegmentIndex
        {
        case 0: Gender.male
        case 1: Gender.female
        case 2: Gender.other
    
        default:
            Gender.unespecified
        }
        
        let user = User(id: id, username: userName, firstName: name, lastName: lastName, gender: gender, birthday: birthDate, provider: .basic, profileImageUrl: "nil")
        
        let db = Firestore.firestore()
        do{
            try db.collection("Users").document(id).setData(from: user)
            
            self.showMessage(type:"User Create", message: "Usser created succesfully")
            
        } catch {
            self.showMessage(type: "Error", message: "Algo a ido mal")
            
        }
        
        
    }
    
    
    
    func validateForm() -> Bool
    {
        let controls = [nameText,lastNameText,adresText,PhoneNumberText,emailText,passText,valPass]
        
        for control in controls {
            if let text = control?.text , text.isEmpty
            {
                showMessage(type:"Error", message: "Error writing user to Firestore")
                return false
            }
        }
        return true
        
    }
    
    func showMessage(type: String, message: String)
    {
        let alert = UIAlertController(title: type, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}
