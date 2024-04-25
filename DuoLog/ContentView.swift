//
//  ContentView.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewStateManager: ViewStateManager
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        switch viewStateManager.viewState {
        case .splash:
            SplashView()
        case .login:
            LoginView(loginViewModel: loginViewModel)
        case .main:
            MainView(mainViewModel: mainViewModel)
        }
    }
}

#Preview {
    ContentView()
}
