//
//  HideKeyboardExtension.swift
//  Devotion
//
//  Created by adam janusewski on 5/10/22.
//

import SwiftUI

// Only run if imporing UIKit
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) 
    }
}
#endif


