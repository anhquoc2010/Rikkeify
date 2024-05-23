//
//  UIImage+Ext.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setNetworkImage(urlString: String) {        
        self.kf.setImage(with: URL(string: urlString), placeholder: UIImage.icApp) { result in
            switch result {
            case .success(let value):
                print("Image downloaded successfully: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
