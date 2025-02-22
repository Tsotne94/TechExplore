//
//  FavouritesView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI
import Foundation

struct FavoritesView: View {
    @State private var isLoading = true
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerView()
                    
                    if isLoading {
                        loadingView()
                    } else {
                        favoritesList()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorites")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
            .onAppear {
                // Simulate loading delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring) {
                        isLoading = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Collection")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Discover your favorite statements")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        VStack(spacing: 20) {
            ForEach(0..<3) { _ in
                FavoriteCardShimmer()
            }
        }
    }
    
    @ViewBuilder
    private func favoritesList() -> some View {
        VStack(spacing: 20) {
            ForEach(1...5, id: \.self) { index in
                FavoriteCard(
                    statement: MockStatement(
                        id: index,
                        title: "Statement #\(index)",
                        description: "This is a sample statement description that showcases the content.",
                        category: "Category \(index)",
                        date: Date()
                    )
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

struct FavoriteCard: View {
    let statement: MockStatement
    @State private var isFavorited = true
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "doc.text.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.1))
                    )
                
                Button {
                    withAnimation(.spring) {
                        isFavorited.toggle()
                    }
                } label: {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(isFavorited ? .red : .gray)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(statement.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(statement.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(statement.category, systemImage: "tag.fill")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Text(statement.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .padding(.top)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct FavoriteCardShimmer: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.2), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: animate ? 400 : -400)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 20)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 40)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 20)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 20)
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
    }
}
