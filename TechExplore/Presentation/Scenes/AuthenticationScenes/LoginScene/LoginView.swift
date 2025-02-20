//
//  LoginView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var viewModel = DefaultLoginViewModel()
    @FocusState private var focusedField: InputField?
    
    @State private var emailAnimation = AnimationState()
    @State private var passwordAnimation = AnimationState()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                SUIAuthHeaderView(title: "Sign In")
                
                inputFieldsGroup
                
                SUIPrimaryButton(title: "Log In", action: viewModel.logIn)
                
                Button {
                    viewModel.signUp()
                } label: {
                    Text("Don't Have An Account? **Sign Up**")
                        .foregroundStyle(.black)
                        .shadow(radius: 5, y: 3)
                }
                
                SUIGradientDivider(text: "or")
                
                SUISocialLoginSection(
                    title: "Continue With",
                    onSocialLogin: { provider in
                        
                    }
                )
                
                Spacer()
            }
            .padding()
            .background(Color.white, ignoresSafeAreaEdges: .all)
            .onChange(of: focusedField) { old, new in
                updateAnimations()
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Failed To Log In"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var inputFieldsGroup: some View {
        Group {
            emailField
            VStack(alignment: .trailing) {
                passwordField
                forgotPasswordButton
            }
        }
    }
    
    private var emailField: some View {
        TextField("", text: $viewModel.email)
            .padding()
            .textFieldStyle(
                width: emailAnimation.width,
                text: "Email",
                animation: emailAnimation.offset
            )
            .textContentType(.emailAddress)
            .focused($focusedField, equals: .email)
    }
    
    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if viewModel.passwordIsHidden {
                    SecureField("", text: $viewModel.password)
                } else {
                    TextField("", text: $viewModel.password)
                }
            }
            .onSubmit {
                viewModel.logIn()
            }
            .frame(height: 55)
            .padding(.leading)
            .textFieldStyle(
                width: passwordAnimation.width,
                text: "Password",
                animation: passwordAnimation.offset
            )
            .focused($focusedField, equals: .password)
            togglePasswordVisibilityButton
        }
    }
    
    private var forgotPasswordButton: some View {
        Button {
            viewModel.forgotPassword()
        } label: {
            Text("Forgot Password")
                .foregroundStyle(.green)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private var togglePasswordVisibilityButton: some View {
        Button {
            viewModel.passwordIsHidden.toggle()
        } label: {
            Image(systemName: viewModel.passwordIsHidden ? "eye" : "eye.slash")
                .padding(.trailing)
                .foregroundStyle(Color.black)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private func updateAnimations() {
        withAnimation(.spring()) {
            emailAnimation.animate(
                for: .email,
                isFocused: focusedField == .email,
                isEmpty: viewModel.email.isEmpty
            )
            
            passwordAnimation.animate(
                for: .password,
                isFocused: focusedField == .password,
                isEmpty: viewModel.password.isEmpty
            )
        }
    }
}


#Preview {
    LoginView()
}
