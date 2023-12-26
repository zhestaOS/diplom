//
//  Post.swift
//  Navigation
//
//  Created by Евгения Шевякова on 22.12.2023.
//

import Foundation

struct Post {
    let postId: String
    let timestamp: Double
    let avatarUrl: String?
    let email: String
    let userId: String
    let text: String
    let imageUrl: String?
    var isFav: Bool
    
    var dictionary: [String: Any] {
        var result = [
            "postId": postId,
            "timestamp": "\(timestamp)",
            "email": email,
            "userId" : userId,
            "text": text,
            "isFav": isFav
        ] as [String : Any]
        if let avatarUrl = avatarUrl {
            result["avatarUrl"] = avatarUrl
        }
        if let imageUrl = imageUrl {
            result["imageUrl"] = imageUrl
        }
        
        return result
    }
}

extension Post {
    init?(dictionary: [String : Any], isFavExternal: Bool? = nil) {
        guard
            let postId = dictionary["postId"] as? String,
            let timestampString = dictionary["timestamp"] as? String,
            let timestamp = Double(timestampString),
            let email = dictionary["email"] as? String,
            let userId = dictionary["userId"] as? String,
            let text = dictionary["text"] as? String,
            var isFav = dictionary["isFav"] as? Bool else { return nil }
        let avatarUrl = dictionary["avatarUrl"] as? String
        let imageUrl = dictionary["imageUrl"] as? String
        
        if let isFavExternal = isFavExternal {
            isFav = isFavExternal
        }
                
        self.init(
            postId: postId,
            timestamp: timestamp,
            avatarUrl: avatarUrl,
            email: email,
            userId: userId,
            text: text,
            imageUrl: imageUrl,
            isFav: isFav
        )
    }
}
