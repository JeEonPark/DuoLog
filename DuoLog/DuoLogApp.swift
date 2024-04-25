//
//  DuoLogApp.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/11.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      do {
          try FirebaseAuth.Auth.auth().signOut()
      } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
      }
      if let user = FirebaseAuth.Auth.auth().currentUser {
          print("로그인 되어 있음", user.uid, user.email ?? "-")
      }

    return true
  }
}


@main
struct DuoLogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewStateManager = ViewStateManager()
    @StateObject var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewStateManager)
                .environmentObject(authManager)
        }
    }
}
