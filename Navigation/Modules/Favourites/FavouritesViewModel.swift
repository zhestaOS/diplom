//
//  FavouritesViewModel.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import Foundation

protocol FavouritesViewModelProtocol {
    var posts: [Post] { get }
    func loadPosts(completion: @escaping () -> Void)
}

final class FavouritesViewModel: FavouritesViewModelProtocol {
    var coordinator: FavouritesCoordinator?
    
    var posts = [Post]()
    
    func loadPosts(completion: @escaping () -> Void) {
        FirestoreService.getFavsPosts { [weak self] posts in
            self?.posts = posts
            completion()
        }
    }
}
