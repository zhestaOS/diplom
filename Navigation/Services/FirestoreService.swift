//
//  FirestoreService.swift
//  Navigation
//
//  Created by Евгения Шевякова on 22.12.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirestoreService {
    enum Collections: String {
        case posts
    }
    
    class func createPost(text: String) {
        guard let userId = AuthService.userId() else { return }
        let posts = Firestore.firestore().collection(Collections.posts.rawValue)
        let post = Post(
            postId: UUID().uuidString,
            avatarUrl: AuthService().avatarUrl(),
            email: AuthService().userEmail(),
            userId: userId,
            text: text,
            imageUrl: nil,
            isFav: false
        )
        posts.addDocument(data: post.dictionary)
    }
    
    class func getAllPosts(completion: @escaping ([Post]) -> Void) {
        let postsCollection = Firestore.firestore().collection(Collections.posts.rawValue)
        let postsQuery = postsCollection.order(by: "timestamp", descending: true)
        postsQuery.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                completion([])
                return
            }
            let models = snapshot.documents.map { (document) -> Post in
                if let post = Post(dictionary: document.data()) {
                    return post
                } else {
                    fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                }
            }
            completion(models)
        }
    }
    
    class func getPosts(userId: String, completion: @escaping ([Post]) -> Void) {
        let postsCollection = Firestore.firestore().collection(Collections.posts.rawValue)
        let postsQuery = postsCollection.whereField("userId", isEqualTo: userId)
        let ordered = postsQuery.order(by: "timestamp", descending: false)
        ordered.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                completion([])
                return
            }
            let models = snapshot.documents.map { (document) -> Post in
                if let post = Post(dictionary: document.data()) {
                    return post
                } else {
                    fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                }
            }
            completion(models)
        }
    }
    
    class func getFavsPosts(completion: @escaping ([Post]) -> Void) {
        let postsCollection = Firestore.firestore().collection(Collections.posts.rawValue)
        let postsQuery = postsCollection.whereField("isFav", isEqualTo: true)
        let ordered = postsQuery.order(by: "timestamp", descending: false)
        
        ordered.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                completion([])
                return
            }
            let models = snapshot.documents.map { (document) -> Post in
                if let post = Post(dictionary: document.data()) {
                    return post
                } else {
                    fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                }
            }
            completion(models)
        }
    }
    
    func updateFavoritesStatus(for postId: String, isFav: Bool, completion: @escaping (Bool, Post?) -> Void) {
        let postRef = Firestore.firestore().collection(Collections.posts.rawValue).whereField("postId", isEqualTo: postId)
        
        postRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                completion(false, nil)
                return
            }
            
            guard let document = snapshot.documents.first else {
                completion(false, nil)
                return
            }
            
            let docRef = Firestore.firestore().collection(Collections.posts.rawValue).document(document.documentID)
            docRef.updateData(["isFav": isFav]) { error in
                if error != nil {
                    completion(false, nil)
                    return
                }
                let post = Post(dictionary: document.data(), isFavExternal: isFav)
                completion(true, post)
            }
        }
    }
    
}
