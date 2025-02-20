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
        HStack {
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
            
            VStack(alignment: .leading, spacing: 20) {
                Text("some info here")
                    .font(.system(.title))
                    .shadow(radius: 2)
                Text("some more")
                    .font(.system(.title2, weight: .medium))
                HStack {
                    Text("some icon here")
                    Image(systemName: "bag.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.red)
                        .frame(maxWidth: 50, maxHeight: 50)
                }
            }
        }
    }
}

#Preview {
    StatementCellView()
}
