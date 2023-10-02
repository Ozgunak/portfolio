//
//  UpdatePasswordView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import SwiftUI

// MARK: If not working re-auth might be necessery

struct UpdatePasswordView: View {
    @State var password: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 12) {
            Text("Update your password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            

            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
                .modifier(TextFieldModifier())
            
            Spacer()
            
            Button {
                Task {
                    if !(password.count <= 6) {
                        try? await AuthenticationManager.shared.updatePassword(password: password)
                        dismiss()
                    }
                }
            } label: {
                Text("Update")
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
    UpdatePasswordView()
}
