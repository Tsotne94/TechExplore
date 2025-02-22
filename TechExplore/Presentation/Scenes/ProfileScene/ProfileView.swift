//
//  ProfileView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var profileUIImage: UIImage? = nil
    @State private var showingAlert = false
    
    private let backgroundColor = Color(.systemGray6)
    private let cardBackgroundColor = Color.white
    private let shadowColor = Color.black.opacity(0.05)
    private let customGreen = Color.customGreen
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection
                        
                        VStack(spacing: 28) {
                            userInformationSection
                            profileFormSection
                            logoutSection
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 25)
                        .padding(.bottom, 40)
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height > 667 ? 60 : 10)
                .refreshable {
                    viewModel.fetchCurrentUser()
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileUIImage)
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
    
    private var headerSection: some View {
        ZStack(alignment: .top) {
            customGreen
                .frame(height: 180)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 20
                    )
                )
                .edgesIgnoringSafeArea(.top)
                .shadow(color: shadowColor, radius: 8, y: 4)
            
            profileImageView
                .offset(y: 130)
        }
        .padding(.bottom, 80)
    }
    
    private var profileImageView: some View {
        ZStack {
            Circle()
                .fill(cardBackgroundColor)
                .frame(width: 140, height: 140)
                .shadow(color: shadowColor, radius: 10, y: 5)
            
            if let uiImage = profileUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            Button(action: { showImagePicker = true }) {
                Circle()
                    .fill(customGreen)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .shadow(color: shadowColor, radius: 5, y: 2)
            }
            .offset(x: 45, y: 45)
        }
    }
    
    private var userInformationSection: some View {
        VStack(spacing: 5) {
            Text("\(viewModel.firstName) \(viewModel.lastName)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(viewModel.email)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var profileFormSection: some View {
        VStack(spacing: 16) {
            Text("Personal Information")
                .font(.headline)
                .foregroundColor(customGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            
            ProfileTextField(
                title: "Name",
                text: .constant(viewModel.firstName),
                icon: "person.fill",
                color: customGreen
            )
            
            ProfileTextField(
                title: "Surname",
                text: .constant(viewModel.lastName),
                icon: "person.text.rectangle.fill",
                color: customGreen
            )
            
            EmailDisplayField(email: viewModel.email, color: customGreen)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackgroundColor)
                .shadow(color: shadowColor, radius: 8, y: 4)
        )
    }
    
    private var logoutSection: some View {
        VStack(spacing: 20) {
            Button(action: { showingAlert = true }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16))
                    Text("Logout")
                        .fontWeight(.medium)
                }
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.red.opacity(0.07))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .alert("Logout", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                viewModel.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

struct ProfileTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField(title, text: $text)
                    .font(.body)
                    .disabled(true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
        )
    }
}

struct EmailDisplayField: View {
    let email: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "envelope.fill")
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(email)
                    .font(.body)
            }
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 12))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
        )
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
