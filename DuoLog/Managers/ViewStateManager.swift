//
//  ViewStateManager.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import SwiftUI

class ViewStateManager: ObservableObject {
    @Published var viewState: ViewState = .splash
}

enum ViewState {
    case splash
    case main
    case login
}
