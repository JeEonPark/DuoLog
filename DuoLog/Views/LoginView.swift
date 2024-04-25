//
//  LoginView.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import SwiftUI
import Firebase
import AuthenticationServices
import CryptoKit

struct LoginView: View {
    @State private var logoOffsetY: CGFloat = 0
    @State private var isSignInButtonVisible: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    @EnvironmentObject var viewStateManager: ViewStateManager
    
    // MARK: - View
    var body: some View {
        ZStack {
            Image("DuoLog-vertical")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(y: logoOffsetY)
                .onTapGesture {
                    loginViewModel.loginWithEmail(email: "test@test.com", password: "test1234")
                    print("Email Login Clicked")
                }
            
            VStack {
                Spacer()
                if isSignInButtonVisible {
                    SignInWithAppleButton{ (request) in
                        loginViewModel.nonce = randomNonceString()
                        request.requestedScopes = [.email, .fullName]
                        request.nonce = sha256(loginViewModel.nonce)
                    } onCompletion: { (result) in
                        switch result {
                        case .success(let user):
                            print("Success")
                            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                print("erorr with firebase")
                                return
                            }
                            loginViewModel.authenticate(credential: credential)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .frame(height: 54)
                    .padding()
                }
            }
        }
        .onAppear {
            withAnimation {
                logoOffsetY = -80
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    isSignInButtonVisible = true
                }
            }
        }
        .onReceive(loginViewModel.$isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                viewStateManager.viewState = .main
            }
        }
    }
}

// MARK: - Preview
//#Preview {
//    LoginView()
//}
