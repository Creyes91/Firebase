//
//  HomeViewController.swift
//  Firebase
//
//  Created by Tardes on 14/1/25.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var mail: String!
    var typeAuth: String!
    
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var typeAuthLabel: UILabel!
    
 
    @IBOutlet weak var MenuView: UIView!
    
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var FAButton: UIButton!
    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        typeAuthLabel.text = typeAuth
        
       
        
        
        // Do any additional setup after loading the view.
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
    
  
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
