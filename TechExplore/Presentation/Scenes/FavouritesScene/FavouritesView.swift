//
//  FavouritesView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct StatementCellView: View {
    var body: some View {
        ZStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .background(.purple.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            VStack {
                Spacer()
                HStack {
                    Text("cool")
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        print("pressed")
                    } label: {
                        Image(systemName: "heart.fill")
                            .renderingMode(.template)
                            .tint(.red)
                    }

                }
                .padding(.horizontal)
            }
            .padding()
        }
        .frame(maxWidth: 200, maxHeight: 200)
    }
}

#Preview {
    StatementCellView()
}
