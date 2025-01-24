//
//  UIimageExtensions.swift
//  Firebase
//
//  Created by Tardes on 23/1/25.
//

import Foundation
import UIKit
import FirebaseStorage



extension UIImageView
{
    
    func loadFrom(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadFrom(url: String)
    {
        self.loadFrom(url: URL(string: url)!)
    }
    
    
    func saveImageToCache(forkey key: String)
    {
        guard let image = self.image else { return }

           // Convertir la imagen a datos PNG
           guard let imageData = image.pngData() else {
               print("Error al convertir la imagen a datos.")
               return
           }

           // Obtener el directorio de caché
           let fileManager = FileManager.default
           if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
               let fileURL = cacheDirectory.appendingPathComponent("\(key).png")
               
               do {
                   // Guardar la imagen en el archivo
                   try imageData.write(to: fileURL)
                   print("Imagen guardada en caché en: \(fileURL.path)")
               } catch {
                   print("Error al guardar la imagen en caché: \(error)")
               }
           }
        
        
    }
    
    func loadImageOfCache(forKey key: String)
    {
        let fileManager = FileManager.default
            if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let fileURL = cacheDirectory.appendingPathComponent("\(key).png")

                // Verificar si el archivo existe en la caché
                if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                    print("Imagen obtenida desde la caché en: \(fileURL.path)")
                    self.image = image  // Asignamos la imagen al UIImageView
                } else {
                    print("Imagen no encontrada en la caché.")
                }
            }
        
        
    }
    
    func uploadImageToStorage(completion: @escaping (Result <URL, Error>) -> Void)
    {
        guard let image = self.image else {
            completion(.failure(NSError(domain: "UIImageView", code: 1, userInfo: [NSLocalizedDescriptionKey: "Empty Data"])))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
                    completion(.failure(NSError(domain: "UIImageView", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error when convert imaage to data."])))
                    return
                }
        
        // Se crea una referencia a la bdStorage
        
        let storageRef = Storage.storage().reference()
        
        let imageRef = storageRef.child("images/Profile.jpg")
        
        // upload image
        
        let uploadTask = imageRef.putData(imageData, metadata: nil){(metadata, error ) in
            if let error = error
            {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL{(url, error) in
                if let error = error
                {
                    completion(.failure(error))
                    return
                }
                
                if let imageUrl = url
                {
                    completion(.success(imageUrl))
                 }
            }
            
            
            
        }
        uploadTask.observe(.progress) { snapshot in
                    let progress = Double(snapshot.progress?.fractionCompleted ?? 0) * 100
                    print("Progreso: \(progress)%")
                }
    }
    
}
