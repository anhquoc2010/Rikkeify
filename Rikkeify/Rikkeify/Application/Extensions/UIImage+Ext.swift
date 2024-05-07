//
//  UIImage+Ext.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String) {
        // Check if the URL is valid
        guard let imageUrl = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession to handle the image request
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            // Check if data is available
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Create UIImage from the downloaded data
            if let image = UIImage(data: data) {
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    // Assign the downloaded image to the image view
                    self.image = image
                }
            } else {
                print("Unable to create image from data")
            }
        }.resume()
    }
}
