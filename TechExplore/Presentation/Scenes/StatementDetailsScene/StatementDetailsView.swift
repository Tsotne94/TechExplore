//
//  StatementDetailsView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct StatementDetailsView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(maxWidth: 30, maxHeight: 30)
                                
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: 20, maxHeight: 20)
                                    .shadow(radius: 2)
                                    .padding(5)
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        Text("title here")
                            .font(.system(size: 30, weight: .bold))
                        Spacer()
                        
                        Button {
                            print("pressed")
                        } label: {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.red)
                                .scaledToFit()
                                .frame(maxWidth: 50, maxHeight: 50)
                        }
                        .padding(.horizontal)
                        .offset(y: -50)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .foregroundStyle(.yellow)
                            .padding(.leading)
                        
                        Text("4.5 = მიდის ქაოტურად")
                    }
                    
                    Text("""
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                        
                        Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                        
                        Curabitur pretium tincidunt lacus. Fusce convallis urna eu augue lacinia, eu maximus nisl tincidunt. Cras laoreet sollicitudin neque, a auctor lorem ullamcorper ac. Nam volutpat velit a neque interdum, et vehicula arcu elementum.
                        """)
                    .padding()                    
                }
            }
        }
        
        Button {
            print("booked")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 150, maxHeight: 70)
                    .foregroundStyle(.green)
                
                HStack {
                    Text("apply now")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .medium))
                    
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: 150, maxHeight: 70)
    }
}

#Preview {
    StatementDetailsView()
}
