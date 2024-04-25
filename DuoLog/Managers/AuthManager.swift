//
//  AuthManager.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import AuthenticationServices
import FirebaseAuth
import CryptoKit

class AuthManager: ObservableObject {
    @Published var user: UserModel?
    private var currentNonce: String?

    // Apple 로그인 요청 처리
    func handleAuthorization(request: ASAuthorizationAppleIDRequest) {
        currentNonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)
    }

    func handleAuthorizationCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
                  let tokenData = appleIDCredential.identityToken,
                  let tokenString = String(data: tokenData, encoding: .utf8),
                  let nonce = currentNonce else {
                print("Error: Authentication failed")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
            signInWithFirebase(credential: credential)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
        
    
    private func signInWithFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let user = authResult?.user {
                self?.user = UserModel(uid: user.uid, name: user.displayName ?? "No Name", email: user.email ?? "No Email")
            } else if let error = error {
                print("Firebase Auth Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: Helper for Apple Login with Firebase
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
