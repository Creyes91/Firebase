//
//  AuthViewController.swift
//  Firebase
//
//  Created by Tardes on 13/1/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthViewController: UIViewController {

  
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth"
        
       // setupGoogleButton()
        
        
        // Do any additional setup after loading the view.
    }
    
  /* func setupGoogleButton()
    {
        let signInButton = GIDSignInButton()
                signInButton.center = view.center  // Centrar el botón en la vista
                view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector (googleSignin), for: .touchUpInside)
        
    }*/
    
    
    func showMessage(type: String, message: String)
    {
        let alert = UIAlertController(title: type, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

   /* @IBAction func CreateUser(_ sender: Any) {
     
        self.performSegue(withIdentifier: "", sender: self)
    }*/
    
    
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
                        guard let user = authResult?.user else {return}
                        
                        SessionManager.shared.saveSession(user: user)
                        
                        self!.performSegue(withIdentifier: "goToHome", sender: self)
                        
                        self!.showMessage(type: "Message", message: "User Logged succesfully")
                
                    }
                    
                }
                
            }
            
          
        
        
        
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  let RegisterViewController = segue.destination as! RegisterViewController
        
        let HomeViewController = segue.destination as! TabViewController
        
      //  RegisterViewController.mail = mail.text
        
        //HomeViewController.typeAuth = checkAuthMethod()
        
    }
    
    func checkAuthMethod()-> String {
        guard let user = Auth.auth().currentUser else {
            return "No hay usuario autenticado."
        }
        
        // Array para guardar los nombres de los proveedores
        var metodos: [String] = []
        
        // Recorremos todos los proveedores asociados con este usuario
        for profile in user.providerData {
            switch profile.providerID {
            case "password":
                metodos.append("Correo y contraseña")
            case "google.com":
                metodos.append("Google")
            case "facebook.com":
                metodos.append("Facebook")
            case "twitter.com":
                metodos.append("Twitter")
            case "phone":
                metodos.append("Teléfono")
            default:
                metodos.append("Otro: \(profile.providerID)")
            }
        }
        
        // Si el usuario no tiene proveedores asociados, devolver un mensaje
        if metodos.isEmpty {
            return "No se encontraron métodos de autenticación."
        }
        
        // Unir todos los métodos en un solo string, separados por coma
        return metodos.joined(separator: ", ")
    }
        
        
    
   
    
    

}

