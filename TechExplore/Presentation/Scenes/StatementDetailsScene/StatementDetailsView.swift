//
//  StatementDetailsView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct StatementDetailsView: View {
    @StateObject private var viewModel: StatementDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(id: Int) {
        _viewModel = StateObject(wrappedValue: StatementDetailsViewModel(id: id))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else if let statement = viewModel.statement {
                        contentView(statement: statement)
                    } else {
                        emptyStateView
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, viewModel.statement != nil ? 80 : 0)
            }
            .safeAreaInset(edge: .top, content: { Color.clear.frame(height: 0) })
            
            if viewModel.statement != nil {
                floatingApplyButton
                    .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
    }
    
    private func contentView(statement: Statement) -> some View {
        VStack(spacing: 0) {
            headerSection(imageURL: statement.imageURL)
            
            VStack(alignment: .leading, spacing: 20) {
                titleSection(title: statement.content)
                categorySection(categories: statement.categories)
                authorSection(authorId: "\(statement.authorId)")
                contentSection(content: statement.content)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxHeight: .infinity)
            .padding(.top, 100)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 40))
            Text("Error: \(message)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No data available")
                .foregroundColor(.gray)
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func headerSection(imageURL: String) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 220)
                            .clipped()
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: geometry.size.width, height: 220)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            }
                    }
                }
                backButton
            }
        }
        .frame(height: 220)
    }
    
    private var backButton: some View {
        Button(action: {
            viewModel.goBack()
            dismiss()
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 36, height: 36)
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 60 : 48)
        .padding(.leading, 20)
    }
    
    private func titleSection(title: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            Button {
                // Heart button action
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .frame(width: 44)
        }
    }
    
    private func categorySection(categories: [Category]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.title) { category in
                    Text(category.title)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func authorSection(authorId: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.gray)
                .font(.system(size: 18))
            Text("Author ID: \(authorId)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
    
    private func contentSection(content: String) -> some View {
        Text(content)
            .font(.body)
            .lineSpacing(6)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var floatingApplyButton: some View {
        Button {
            // Apply action
        } label: {
            HStack(spacing: 8) {
                Text("Apply Now")
                    .font(.system(size: 16, weight: .semibold))
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.green)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}
