//
//  SplashView.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/12.
//

import SwiftUI
import Firebase

struct SplashView: View {
    @EnvironmentObject var viewStateManager: ViewStateManager
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Image("DuoLog-vertical")
            .resizable()
            .frame(width: 100, height: 100)
            .onAppear {
                if let currentUser = Auth.auth().currentUser {
                    authManager.user = UserModel(uid: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewStateManager.viewState = .main
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewStateManager.viewState = .login
                    }
                }
            }
    }
    
}

#Preview {
    SplashView()
}
