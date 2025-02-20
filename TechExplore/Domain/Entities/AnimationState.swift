//
//  AnimationState.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

public struct AnimationState {
    var width: CGFloat = 0
    var offset: CGFloat = 0
    
    mutating func animate(for field: InputField, isFocused: Bool, isEmpty: Bool) {
        if isEmpty && !isFocused {
            width = 0
            offset = 0
        } else {
            width = field.labelWidth
            offset = -30
        }
    }
}
