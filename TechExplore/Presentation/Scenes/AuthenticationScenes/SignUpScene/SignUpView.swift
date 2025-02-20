//
//  SignUpView.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = DefaultSignUpViewModel()
    @FocusState private var focusedField: InputField?
    
    @State private var nameAnimation = AnimationState()
    @State private var emailAnimation = AnimationState()
    @State private var passwordAnimation = AnimationState()
    @State private var confirmPasswordAnimation = AnimationState()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 35) {
                SUIAuthHeaderView(title: "Sign Up")
                
                inputFieldsGroup
                
                VStack(spacing: 20) {
                    signUpButton
                    alreadyHaveAccountButton
                    SUIGradientDivider(text: "or")
                    SUISocialLoginSection(title: "") { idk in
                        
                    }
                }
                Spacer(minLength: 20)
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    
        .background(Color.white, ignoresSafeAreaEdges: .all)
        .onChange(of: focusedField) { first, second in
            updateAnimations()
        }
        .overlay {
            if viewModel.isLoading {
//                SUILoader()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var inputFieldsGroup: some View {
        Group {
            nameField
                .padding(.horizontal, 5)
            emailField
                .padding(.horizontal, 5)
            passwordField
                .padding(.horizontal, 5)
            confirmPasswordField
                .padding(.horizontal, 5)
        }
    }
    
    private var nameField: some View {
        TextField("", text: $viewModel.name)
            .padding()
            .textFieldStyle(
                width: nameAnimation.width,
                text: "Username",
                animation: nameAnimation.offset
            )
            .focused($focusedField, equals: .name)
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
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
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
            .frame(height: 55)
            .padding(.leading)
            .textFieldStyle(
                width: passwordAnimation.width,
                text: "Password",
                animation: passwordAnimation.offset
            )
            .textContentType(.newPassword)
            .focused($focusedField, equals: .password)
            
            togglePasswordVisibilityButton
        }
    }
    
    private var confirmPasswordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if viewModel.confirmPasswordHidden {
                    SecureField("", text: $viewModel.confirmPasswod)
                } else {
                        TextField("", text: $viewModel.confirmPasswod)
                }
            }
            .frame(height: 55)
            .padding(.leading)
            .textFieldStyle(
                width: confirmPasswordAnimation.width,
                text: "Confirm Password",
                animation: confirmPasswordAnimation.offset
            )
            .textContentType(.newPassword)
            .focused($focusedField, equals: .confirmPassword)
            
            toggleConfirmPasswordVisibilityButton
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
    
    private var toggleConfirmPasswordVisibilityButton: some View {
        Button {
            viewModel.confirmPasswordHidden.toggle()
        } label: {
            Image(systemName: viewModel.confirmPasswordHidden ? "eye" : "eye.slash")
                .padding(.trailing)
                .foregroundStyle(Color.black)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private var signUpButton: some View {
        Button {
            viewModel.signUp()
            print("does this even being called?")
        } label: {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.green)
                .cornerRadius(10)
        }
        .shadow(radius: 5, y: 3)
    }
    
    private var alreadyHaveAccountButton: some View {
        Button {
            viewModel.goToLogin()
        } label: {
            Text("Already Have An Account? **Log In**")
                .foregroundColor(.black)
                .font(.subheadline)
        }
    }
    
    private func updateAnimations() {
        withAnimation(.spring()) {
            nameAnimation.animate(
                for: .name,
                isFocused: focusedField == .name,
                isEmpty: viewModel.name.isEmpty
            )
            
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
            
            confirmPasswordAnimation.animate(
                for: .confirmPassword,
                isFocused: focusedField == .confirmPassword,
                isEmpty: viewModel.confirmPasswod.isEmpty
            )
        }
    }
}

#Preview {
    SignUpView()
}
