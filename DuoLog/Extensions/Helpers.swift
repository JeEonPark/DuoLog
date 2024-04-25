//
//  Helpers.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/16.
//

import SwiftUI

/// Corner Radius를 각 edge마다 커스텀 하기 윈한 struct
struct RoundedCorner: Shape {
  
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
