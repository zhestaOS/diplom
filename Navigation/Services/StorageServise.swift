//
//  StorageServise.swift
//  Navigation
//
//  Created by Евгения Шевякова on 24.12.2023.
//

import UIKit
import FirebaseStorage

final class StorageServise {
    func upload(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let data = image.pngData() else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images/" + UUID().uuidString + ".jpg")
        
        let uploadTask = imagesRef.putData(data) { metadata, error in
            imagesRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }
    
    func download(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let imgReference = storage.reference(forURL: urlString)
        imgReference.getData(maxSize: 6 * 1024 * 1024) { data, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
}
