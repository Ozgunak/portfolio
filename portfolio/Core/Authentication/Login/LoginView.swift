//
//  LoginView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        VStack {
            TextField("Enter your email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
            SecureField("Enter your password", text: $viewModel.password)
                .modifier(TextFieldModifier())
        }
        
        NavigationLink(destination: {
            ForgotView()
        }, label: {
            Text("Forgot Password?")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.trailing, 28)
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
        
        
        Button {
            Task {
                try await viewModel.login()
                showSignInView = false
            }
        } label: {
            Text("Login")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 360, height: 44)
                .background(.blue.gradient)
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(.vertical)
        
        NavigationLink {
            RegisterView(showSignInView: $showSignInView)
                .navigationBarBackButtonHidden()
        } label: {
            Group {
                Text("Don't have an account? ") +
                Text("Sign Up")
                .fontWeight(.semibold)
            }
            .font(.subheadline)
        }
        .padding(.bottom)
        
    }
}

#Preview {
    NavigationStack {
        LoginView(showSignInView: .constant(true))
    }
}
