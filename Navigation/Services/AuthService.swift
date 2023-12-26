//
//  AuthService.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import Foundation
import FirebaseAuth

enum AuthError: Error {
    case emptyFields
    case incorrectEmail
    case incorrectPassword
    
    case fbRegEmailAlreadyInUse(desc: String)
    case fbRegInvalidEmail(desc: String)
    case fbRegWeakPassword(desc: String)
    case fbRegUnexpected(desc: String)
    
    case fbAuthInvalidCredential(desc: String)
    case fbAuthInvalidEmail(desc: String)
    case fbAuthWrongPassword(desc: String)
    case fbAuthUnexpected(desc: String)
}

final class AuthService {
    func isLogged() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    class func userId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func userEmail() -> String {
        return Auth.auth().currentUser?.email ?? "no email"
    }
    
    func addAvatarUrl(urlString: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = URL(string: urlString)
        changeRequest?.commitChanges()
    }
    
    func avatarUrl() -> String? {
        return Auth.auth().currentUser?.photoURL?.absoluteString
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        if let error = checkCredentials(email: email, password: password) {
            completion(.failure(error))
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                let err = error as NSError
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(.failure(AuthError.fbRegEmailAlreadyInUse(desc: err.localizedDescription)))
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(.failure(AuthError.fbRegInvalidEmail(desc: err.localizedDescription)))
                case AuthErrorCode.weakPassword.rawValue:
                    completion(.failure(AuthError.fbRegWeakPassword(desc: err.localizedDescription)))
                default:
                    completion(.failure(AuthError.fbRegUnexpected(desc: err.localizedDescription)))
                }
                return
            }
            if let email = authDataResult?.user.email {
                completion(.success(email))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        if let error = checkCredentials(email: email, password: password) {
            completion(.failure(error))
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error, authDataResult?.user == nil {
                print(error.localizedDescription)
                let err = error as NSError
                switch err.code {
                case AuthErrorCode.invalidCredential.rawValue:
                    completion(.failure(AuthError.fbAuthInvalidCredential(desc: err.localizedDescription)))
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(.failure(AuthError.fbAuthInvalidEmail(desc: err.localizedDescription)))
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(.failure(AuthError.fbAuthWrongPassword(desc: err.localizedDescription)))
                default:
                    completion(.failure(AuthError.fbAuthUnexpected(desc: err.localizedDescription)))
                }
                return
            }
            
            if let email = authDataResult?.user.email {
                completion(.success(email))
            }
        }
    }
    
    private func checkCredentials(email: String, password: String) -> AuthError? {
        guard !email.isEmpty || !password.isEmpty else {
            print("Пустое поле")
            return .emptyFields
        }
        
        guard isValidEmail(email) else {
            print("Email введен некорректно")
            return .incorrectEmail
        }
        
        guard password.count >= 6 else {
            print("Пароль введен некорректно")
            return .incorrectPassword
        }
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
