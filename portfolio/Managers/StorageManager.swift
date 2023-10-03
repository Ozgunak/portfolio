//
//  StorageManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import UIKit
import Firebase
import FirebaseStorage

enum StoragePath {
    case user
    case project
    
    var stringValue: String {
        switch self {
        case .user:
            return "profileImages"
        case .project:
            return "projects"
        }
    }
}

struct StorageManager {
    static func uploadImage(image: UIImage, savePath: StoragePath) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(savePath.stringValue)/\(fileName)")
        
        do {
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"
            let _ = try await ref.putDataAsync(imageData, metadata: meta)
            let url = try await ref.downloadURL()
            print("Succesfully uploaded Data!")
            return url.absoluteString
        } catch {
            print("Error: upload image \(error.localizedDescription)")
            return nil
        }
    }
}
