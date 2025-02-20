//
//  UIView+TextfieldStyle.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

extension View {
    func textFieldStyle(width: CGFloat, text: String, animation: CGFloat) -> some View {
        modifier(SUICustomTextFieldStyle(width: width, text: text, animation: animation))
    }
}
