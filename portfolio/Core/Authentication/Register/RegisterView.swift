//
//  RegisterView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = RegistrationViewModel()
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
            
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
            
            SecureField("Password", text: $viewModel.password)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
            
            Spacer()
            
            Button {
                Task {
//                    if isCredential {
//                        try await viewModel.linkUser()
//                    } else {
                        try await viewModel.createUser()
//                    }
                    showSignInView = false
                }
            } label: {
                Text("Complete Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 44)
                    .background(.blue.gradient)
                    .clipShape(.rect(cornerRadius: 8))
            }
            .padding(.vertical)
            
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