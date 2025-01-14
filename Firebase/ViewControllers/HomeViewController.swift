//
//  HomeViewController.swift
//  Firebase
//
//  Created by Tardes on 14/1/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    var mail: String!
    var typeAuth: String!
    
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var typeAuthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = mail
        typeAuthLabel.text = typeAuth
        
        // Do any additional setup after loading the view.
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
