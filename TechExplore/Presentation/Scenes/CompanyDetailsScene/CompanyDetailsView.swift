//
//  CompanyDetailsView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct CompanyDetailsView: View {
    let griditems = GridItem(.flexible(), spacing: 20)
    var body: some View {
        VStack {
            header()
            ScrollView {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 150)
            Text("Company name")
                .font(.system(size: 25, weight: .black))
                .padding(.bottom)
            
            Text("small description about company, whatewer is needed i dont know")
                .padding(.horizontal, 50)
            
                LazyVGrid(columns: Array(repeating: griditems, count: 3)) {
                    ForEach(1...5, id: \.self) { num in
                        FavoriteCard(statement: MockStatement(id: 1, title: "cool cool", description: "safsf", category: "sdsdsd", date: Date()))
                            .frame(maxHeight: 100)
                    }
                }.padding()
            }
        }
    }
    
    private func header() -> some View {
        ZStack {
            HStack {
                Button {
                    print("back tapped")
                } label: {
                    Image(systemName: "chevron.left")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    CompanyDetailsView()
}
