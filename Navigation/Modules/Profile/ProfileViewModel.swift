//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

protocol ProfileViewModelProtocol {
    var posts: [Post] { get }
    func userEmail() -> String
    func updateAvatar(image: UIImage, completion: @escaping (Bool) -> Void)
    func userAvatar(completion: @escaping (UIImage) -> Void)
    func handleCreatePostButtonTapped(vc: UIViewController, completion: @escaping () -> Void)
    func loadPosts(completion: @escaping () -> Void)
    func logout()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var coordinator: ProfileCoordinator?
    let authService: AuthService
    let firestoreService: FirestoreService
    let storageService: StorageServise
    
    var posts = [Post]()
    
    init(
        authService: AuthService = AuthService(),
        firestoreService: FirestoreService = FirestoreService(),
        storageService: StorageServise = StorageServise()
    ) {
        self.authService = authService
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    func userEmail() -> String {
        authService.userEmail()
    }
    
    func userAvatar(completion: @escaping (UIImage) -> Void) {
        guard let avatarUrl = authService.avatarUrl() else { return }
        storageService.download(urlString: avatarUrl) { image in
            guard let image = image else { return }
            completion(image)
        }
    }
    
    func loadPosts(completion: @escaping () -> Void) {
        guard let userId = AuthService.userId() else {
            completion()
            return
        }
        FirestoreService.getPosts(userId: userId) { [weak self] posts in
            self?.posts = posts
            completion()
        }
    }
    
    func updateAvatar(image: UIImage, completion: @escaping (Bool) -> Void) {
        StorageServise().upload(image: image) { [weak self] urlString in
            guard let urlString = urlString else {
                completion(false)
                return
            }
            self?.authService.addAvatarUrl(urlString: urlString)
            completion(true)
        }
    }
    
    func handleCreatePostButtonTapped(vc: UIViewController, completion: @escaping () -> Void) {
        coordinator?.openCreatePost(from: vc, callback: { text in
            FirestoreService.createPost(text: text)
            completion()
        })
    }
    
    func logout() {
        authService.logout()
        coordinator?.logout()
    }
}
