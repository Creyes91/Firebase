//
//  SettingsTableViewController.swift
//  Firebase
//
//  Created by Tardes on 23/1/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
        ProfileImage.loadImageOfCache(forKey: "ProfileImage")
        
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
        
        ProfileImage.layer.cornerRadius = ProfileImage.frame.size.width / 2
       
        
        ProfileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        ProfileImage.addGestureRecognizer(tapGesture)
    }
        @objc func imageTapped ()
        {
            showImageSourceOption()
            
        }
        
        func showImageSourceOption()
        {
            let alertController = UIAlertController(title: "Seleccionar Imagen", message: "Elige una fuente de imagen", preferredStyle: .actionSheet)

                   // Opción de elegir la imagen desde la galería
                   let galleryAction = UIAlertAction(title: "Galería", style: .default) { _ in
                       self.openImagePicker(sourceType: .photoLibrary)
                   }

                   // Opción de usar la cámara
                   let cameraAction = UIAlertAction(title: "Cámara", style: .default) { _ in
                       self.openImagePicker(sourceType: .camera)
                   }

                   // Opción de cancelar
                   let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

                   // Agregar las acciones al UIAlertController
                   alertController.addAction(galleryAction)
                   alertController.addAction(cameraAction)
                   alertController.addAction(cancelAction)

                   // Mostrar el UIAlertController
                   present(alertController, animated: true, completion: nil)
               }

               // Función para abrir el UIImagePickerController con el sourceType adecuado
               func openImagePicker(sourceType: UIImagePickerController.SourceType) {
                   if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                       let imagePickerController = UIImagePickerController()
                       imagePickerController.delegate = self
                       imagePickerController.sourceType = sourceType
                       present(imagePickerController, animated: true, completion: nil)
                   } else {
                       // Si no se puede acceder a la cámara o galería, muestra una alerta
                       let errorAlert = UIAlertController(title: "Error", message: "No se puede acceder a la fuente seleccionada.", preferredStyle: .alert)
                       errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       present(errorAlert, animated: true, completion: nil)
                   }
               }

               // Delegate methods del UIImagePickerController
               func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                   if let selectedImage = info[.originalImage] as? UIImage {
                       ProfileImage.image = selectedImage
                       ProfileImage.saveImageToCache(forkey: "ProfileImage")
                       ProfileImage.uploadImageToStorage{ result in
                           switch result {
                           case .success(let imageUrl):
                               print("Imagen subida con éxito. URL: \(imageUrl.absoluteString)")
                                           // Aquí puedes hacer lo que quieras con la URL, como guardarla en Firestore o mostrarla en la UI
                            case .failure(let error):
                                print("Error al subir la imagen: \(error.localizedDescription)")
                                           // Maneja el error, por ejemplo, mostrando un mensaje al usuario
                                       
                           }
                           
                       }
                   }
                   dismiss(animated: true, completion: nil)
               }

               func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                   dismiss(animated: true, completion: nil)
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
        
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
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
