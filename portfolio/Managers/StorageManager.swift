//
//  StorageManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import UIKit
import Firebase
import FirebaseStorage

enum StoragePath: String {
    case users
    case projects
    case videos
}

struct StorageManager {
    static func uploadImage(image: UIImage, savePath: StoragePath) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(savePath.rawValue)/\(fileName)")
        
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
    
    static func uploadVideo(data: Data) async throws -> String? {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(StoragePath.videos.rawValue)/\(fileName)")
        let meta = StorageMetadata()
        meta.contentType = "video/quicktime"
        
        do {
            let _ = try await ref.putDataAsync(data, metadata: meta)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("Error: uploading image \(error.localizedDescription)")
            return nil
        }
    }
}
