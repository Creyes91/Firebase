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
import FirebaseFirestore

class InitViewController: UIViewController {
    
    @IBOutlet weak var EmailPasswordButton: UIButton!
    @IBOutlet weak var GoogleButton: UIButton!
    let alert = UIAlertController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SessionManager.shared.isAuthenticated()
        {
            performSegue(withIdentifier: "goToHome", sender: self)
            
            
        }
        
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
                
                
                if error != nil
                    
                {
                    print ("Error")
                    
                }
                
                else {
                    print("auth")
                    guard let user = result?.user else {return}
                    let db = Firestore.firestore()
                    let docRef = db.collection("Users").document(user.uid)
                    
                    docRef.getDocument{ (document, error) in
                        if let error = error {
                                    print("Error al obtener el documento: \(error.localizedDescription)")
                                    return
                                }
                        
                        if let document = document, !document.exists || user.metadata.creationDate == user.metadata.lastSignInDate
                        {
                            
                            print("Redirigiendo a la pantalla de registro")
                            self.performSegue(withIdentifier: "goToRegister", sender: self)
                        } else {
                            SessionManager.shared.saveSession(user: user)
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                            
                        }
                        
                        
                    }
                    
                    // Verificar si es un usuario nuevo
             /*       if user.metadata.creationDate == user.metadata.lastSignInDate  {
                        // Si es un usuario nuevo, redirigir a la pantalla de registro
                        print("Redirigiendo a la pantalla de registro")
                        self.performSegue(withIdentifier: "goToRegister", sender: self)
                    } else {
                        // Si ya es un usuario registrado, redirigir a la pantalla de inicio
                        SessionManager.shared.saveSession(user: user)
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }*/
                    
                    // Mostrar mensaje de éxito
                    self.alert.showMessage(type: "Message", message: "User Logged successfully")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToRegister"{
            let Form = segue.destination as! RegisterViewController
            Form.googleRegister = true
            
            
        }
    }
    
  
    
    
}
