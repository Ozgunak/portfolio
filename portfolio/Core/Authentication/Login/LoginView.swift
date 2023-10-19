//
//  LoginView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct LoginView: View {
    enum Field { case email, password }
    @StateObject var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    @State private var isAlertShowing: Bool = false
    @State private var alertMessage: String = ""
    @State private var buttonsDisabled: Bool = true
    @FocusState private var focusField: Field?

    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                    .submitLabel(.next)
                
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: viewModel.email) {
                        buttonsDisabled = !viewModel.isValidInput()
                    }
                    .onAppear {
                        buttonsDisabled = !viewModel.isValidInput()
                    }
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(TextFieldModifier())
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = .none
                    }
                    .onChange(of: viewModel.password) {
                        buttonsDisabled = !viewModel.isValidInput()
                    }
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
                    do {
                        try await viewModel.login()
                        showSignInView = false
                    } catch {
                        print("Error : sign in \(error.localizedDescription)")
                        alertMessage = "Error: sign in \(error.localizedDescription)"
                        isAlertShowing = true
                    }
                }
            } label: {
                Text("Login")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 44)
                    .background(buttonsDisabled ? Color.gray.gradient : Color.blue.gradient)
                    .clipShape(.rect(cornerRadius: 8))
            }
            .disabled(buttonsDisabled)
            .padding(.vertical)
            .alert(alertMessage, isPresented: $isAlertShowing) {
                Button("OK", role: .cancel) {}
            }
            
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
       
}

#Preview {
        LoginView(showSignInView: .constant(true))
}
