//
//  UIimageExtensions.swift
//  Firebase
//
//  Created by Tardes on 23/1/25.
//

import Foundation
import UIKit


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
        let image = self.image?.pngData()
        
        let cache = URLCache.shared
        let response = HTTPURLResponse(url: URL(string: "https://example.com/\(key)")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let cachedResponse = CachedURLResponse(response: response!, data: image!)
        
        cache.storeCachedResponse(cachedResponse, for: URLRequest(url: URL(string: "https://example.com/\(key)")!))
        
        print("Imagen guardada en caché con clave \(key)")
        
        
    }
    
    func loadImageOfCache(forKey key: String)
    {
        let cache = URLCache.shared
        
        let url = URL(string: "https://example.com/\(key)")!
        let request = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: request) {
                    // Convertimos los datos de la respuesta en una imagen
                    if let image = UIImage(data: cachedResponse.data) {
                        print("Imagen obtenida desde la caché")
                        self.image = image  // Asignamos la imagen al UIImageView
                    }
                } else {
                    print("Imagen no encontrada en la caché")
                }
        
        
    }
    
}
