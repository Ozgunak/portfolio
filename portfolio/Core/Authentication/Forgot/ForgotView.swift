//
//  ForgotView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import SwiftUI

struct ForgotView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ForgotViewModel()
    
    var body: some View {
        
        VStack(spacing: 12) {
            Text("Reset your password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            

            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())

            
            Spacer()
            
            Button {
                Task {
                    if !viewModel.email.isEmpty {
                        try? await viewModel.resetPassword()
                        dismiss()
                    }
                }
            } label: {
                Text("Send Email")
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
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    ForgotView()
}
