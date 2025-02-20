//
//  GradientDivider.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//

import SwiftUI

struct SUIGradientDivider: View {
    let text: String
    
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.black, .white, .black]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay {
                Text(text)
            }
    }
}
