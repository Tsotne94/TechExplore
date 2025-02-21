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
    @State private var searchText = ""
    @State private var activeTag: Tag = .first
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
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        }
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .contentMargins(.top, 190, for: .scrollIndicators)
        .background(.customGreen.opacity(0.05))
    }
    
    @ViewBuilder
    private func navigationBar(_ title: String = "Home Page") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let progress = isSearching ? 1 : max(min((-minY / 70), 1), 0)
            
            VStack(spacing: 10) {
                titleView(title)
                searchBar(progress)
                tagsScrollView()
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
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
            
            TextField("Search Program", text: $searchText)
                .focused($isSearching)
            
            if isSearching {
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
                            activeTag = tag
                        }
                    } label: {
                        Text(tag.rawValue)
                            .font(.callout)
                            .foregroundStyle(activeTag == tag ? Color.white : Color.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background {
                                if activeTag == tag {
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
        ForEach(0...20, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55, height: 55)
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    Rectangle()
                        .frame(height: 8)
                    Rectangle()
                        .frame(width: 88, height: 8)
                }
            }
            .foregroundStyle(.gray.opacity(0.5))
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
