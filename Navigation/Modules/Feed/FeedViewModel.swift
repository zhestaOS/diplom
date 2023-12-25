//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import Foundation

protocol FeedViewModelProtocol {
    var posts: [Post] { get }
    func loadPosts(completion: @escaping () -> Void)
}

final class FeedViewModel: FeedViewModelProtocol {
    var coordinator: FeedCoordinator?
    var posts = [Post]()
    
    func loadPosts(completion: @escaping () -> Void) {
        guard let userId = AuthService.userId() else {
            completion()
            return
        }
        FirestoreService.getAllPosts { [weak self] posts in
            self?.posts = posts
            completion()
        }
    }
}
