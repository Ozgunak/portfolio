//
//  RegisterView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct RegisterView: View {
    enum RegisterField { case email, password, username }
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = RegistrationViewModel()
    @State private var isAlertShowing: Bool = false
    @State private var alertMessage: String = ""
    @State private var showContext: Bool = false
    @State private var buttonsDisabled: Bool = true
    @FocusState private var focusField: RegisterField?
    @State private var isLoading: Bool = false
    @Binding var showSignInView: Bool
    let isCredential: Bool
    
    init(showSignInView: Binding<Bool>, isCredential: Bool = false) {
        self._showSignInView = showSignInView
        self.isCredential = isCredential
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Create an account")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            TextField("Username", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .modifier(TextFieldModifier())
                .submitLabel(.next)
                .focused($focusField, equals: .username)
                .onSubmit {
                    focusField = .email
                }
                .onChange(of: viewModel.username) {
                    buttonsDisabled = viewModel.isValidInput()
                }
                .onAppear {
                    buttonsDisabled = viewModel.isValidInput()
                }
            
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
                .submitLabel(.next)
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = .password
                }
                .onChange(of: viewModel.email) {
                    buttonsDisabled = viewModel.isValidInput()
                }

            
            SecureField("Password", text: $viewModel.password)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
                .submitLabel(.done)
                .focused($focusField, equals: .password)
                .onSubmit {
                    focusField = .none
                }
                .onChange(of: viewModel.password) {
                    buttonsDisabled = viewModel.isValidInput()
                }

            Spacer()
            
            Button {
                Task {
                    do {
                        try await viewModel.createUser()
                        showSignInView = false
                        return
                    } catch {
                        print("Error 1: register \(error.localizedDescription)")
                        alertMessage = "Error: \(error.localizedDescription)"
                    }
//                    if isCredential {
//                        try await viewModel.linkUser()
//                    } else {
//                    }
                    isAlertShowing = true

                }
            } label: {
                Text("Complete Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 44)
                    .background(buttonsDisabled ? Color.gray.gradient : Color.blue.gradient)
                    .clipShape(.rect(cornerRadius: 8))
                    .disabled(buttonsDisabled)
            }
            .padding(.vertical)
            .alert(alertMessage, isPresented: $isAlertShowing) {
                Button("OK", role: .cancel) {}
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        
    }
}

#Preview {
    RegisterView(showSignInView: .constant(true))
}
