//
//  SettingsTableViewController.swift
//  Firebase
//
//  Created by Tardes on 23/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var usernameFieldText: UILabel!
    @IBOutlet weak var lastNameFieldText: UILabel!
    @IBOutlet weak var nameFieldText: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var genderFieldText: UILabel!
    @IBOutlet weak var BirthDateFieldText: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let docRef = db.collection("Users").document(userID)
        
        Task {
            do {
                user = try await docRef.getDocument(as: User.self)
                DispatchQueue.main.async {
                    self.loadData()
                }
            } catch {
                print("Error decoding user: \(error)")
            }
            }
            
        }
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/


    func loadData()
    {
        nameFieldText.text = user.firstName
        lastNameFieldText.text = user.lastName
        usernameFieldText.text = user.username
        
        switch user.gender {
        case .male:
            genderFieldText.text = "Male"
        case .female:
            genderFieldText.text = "Female"
        default:
            genderFieldText.text = "Other"
       
            
        }
        
        let formater = DateFormatter()
        formater.dateStyle = .medium
        
        if let date = user.birthday {
            BirthDateFieldText.text = formater.string(from: date)
        }else {
            BirthDateFieldText.text = "--/--/----"
        }
        
    /*    if let imageUrl = user.profileImageUrl {
            ProfileImage.loadFrom(url: imageUrl)
        }*/
        
    }


   
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            SessionManager.shared.clearSession()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
            
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
