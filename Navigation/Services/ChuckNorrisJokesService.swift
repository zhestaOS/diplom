//
//  ChuckNorrisJokesService.swift
//  Navigation
//
//  Created by Евгения Шевякова on 26.12.2023.
//

import Foundation

final class ChuckNorrisJokesService {
    private struct Answer: Decodable {
        var categories: [String]
        var created_at: String
        var icon_url: String
        var id: String
        var updated_at: String
        var url: String
        var value: String
    }
    
    func chuckNorrisPost(completion: @escaping (Post?) -> Void) {
        downloadJoke { answer in
            guard let answer = answer else {
                completion(nil)
                return
            }
            let post = Post(
                postId: UUID().uuidString,
                timestamp: Date().timeIntervalSince1970,
                avatarUrl: "https://firebasestorage.googleapis.com:443/v0/b/navigation-de5bf.appspot.com/o/images%2F82CAAB7A-6C54-4EAF-A7F9-C58F01F5A7CE.jpg?alt=media&token=64f12f97-b120-45e4-a737-7353b61c9ce2",
                email: "chuck@norris.com",
                userId: "1234567890",
                text: answer.value,
                imageUrl: nil,
                isFav: false
            )
            completion(post)
        }
    }
    
    private func downloadJoke(completion: @escaping (Answer?) -> Void) {
        let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            if !((200..<300).contains(httpResponse.statusCode)) {
                completion(nil)
                return
            }

            guard let data else {
                completion(nil)
                return
            }
            
            do {
                let answer = try JSONDecoder().decode(Answer.self, from: data)
                completion(answer)
            } catch {
                completion(nil)
                print(error)
            }
        }
        
        task.resume()
    }
}
