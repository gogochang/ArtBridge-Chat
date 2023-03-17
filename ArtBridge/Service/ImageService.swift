//
//  ImageUploader.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/10.
//

import Foundation
import Firebase

struct ImageService {
    static func uploadImage(image: UIImage?, completion: @escaping(String) -> Void) {
        guard let image = image else {
            // 이미지가 없을 때는 ""를 보내준다. (postService에서 사용함)
            completion("")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.01) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("ImageUploader - Failed to upload image with error : \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    // Url String을 이용하여 이미지를 가져온다.
    static func loadImageFromUrl( _ urlString: String, completion: @escaping(Data) -> Void) {
        print("loadImageFromUrl() called1")
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
}
