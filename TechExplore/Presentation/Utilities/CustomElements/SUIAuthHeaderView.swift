//
//  SUIAuthHeaderView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct SUIAuthHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: UIScreen.main.bounds.height > 667 ? 45 : 35, weight: .bold))
                .frame(width: UIScreen.main.bounds.height > 667 ? 230 : 350)
                .shadow(radius: 5, y: 3)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}
