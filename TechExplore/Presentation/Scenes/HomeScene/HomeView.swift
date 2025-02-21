//
//  HomeView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct Home: View {
    @StateObject private var viewModel = HomeViewModel()
    @FocusState private var isSearching: Bool
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                messagesList()
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                navigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: viewModel.isSearching)
        }
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .contentMargins(.top, 190, for: .scrollIndicators)
        .background(.customGreen.opacity(0.05))
        .onChange(of: isSearching) { _, newValue in
            viewModel.toggleSearch(newValue)
        }
    }
    
    @ViewBuilder
    private func navigationBar(_ title: String = "Home Page") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let progress = viewModel.isSearching ? 1 : max(min((-minY / 70), 1), 0)
            
            VStack(spacing: 10) {
                titleView(title)
                searchBar(progress)
                tagsScrollView()
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || viewModel.isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, viewModel.isSearching ? -65 : 0)
    }
    
    @ViewBuilder
    private func titleView(_ title: String) -> some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func searchBar(_ progress: CGFloat) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
            
            TextField("Search Program", text: $viewModel.searchText)
                .focused($isSearching)
            
            if viewModel.isSearching {
                Button {
                    isSearching = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                }
                .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            }
        }
        .foregroundStyle(.primary)
        .padding(.vertical, 10)
        .padding(.horizontal, 15 - (progress * 15))
        .frame(height: 45)
        .clipShape(Capsule())
        .background {
            RoundedRectangle(cornerRadius: 15 - (progress * 25))
                .fill(.background)
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                .padding(.top, -progress * 190)
                .padding(.bottom, -progress * 65)
                .padding(.horizontal, -progress * 15)
        }
    }
    
    @ViewBuilder
    private func tagsScrollView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(Tag.allCases, id: \.rawValue) { tag in
                    Button {
                        withAnimation(.snappy) {
                            viewModel.updateActiveTag(tag)
                        }
                    } label: {
                        Text(tag.rawValue)
                            .font(.callout)
                            .foregroundStyle(viewModel.activeTag == tag ? Color.white : Color.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background {
                                if viewModel.activeTag == tag {
                                    Capsule()
                                        .fill(.customGreen)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                } else {
                                    Capsule()
                                        .fill(.customGreen.opacity(0.2))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    private func messagesList() -> some View {
        ForEach(viewModel.messages) { message in
            Button {
                viewModel.goToDetails(message: message)
            } label: {
                HStack(spacing: 12) {
                    Circle()
                        .frame(width: 55, height: 55)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(message.title)
                            .font(.headline)
                        Text(message.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(message.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 15)
        }
    }
}

struct CustomScrollTargetBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    HomeView()
}
