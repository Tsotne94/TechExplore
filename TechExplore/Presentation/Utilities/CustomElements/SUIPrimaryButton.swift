//
//  SUIPrimaryButton.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct SUIPrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .frame(height: 55)
                .overlay {
                    Text(title)
                        .bold()
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .foregroundStyle(.green)
                .shadow(radius: 10, y: 5)
        }
    }
}
