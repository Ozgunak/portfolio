//
//  SignUpPromoteView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-18.
//

import SwiftUI
import Firebase

struct SignUpPromoteView: View {
    @State var showLogin: Bool = false 
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                Text("Join us, and get more features!")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                BenefitView(text: "Like and save favorite projects", symbolName: "heart.circle")
                BenefitView(text: "Comment on projects", symbolName: "text.bubble")
                BenefitView(text: "Send messages to users", symbolName: "envelope")
                BenefitView(text: "Create and customize your profile", symbolName: "person.crop.circle")
                BenefitView(text: "Post and manage your projects", symbolName: "folder")

                Spacer()

                Button(action: {
                    showLogin.toggle()
                }) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showLogin) {
            LoginView(showSignInView: $showLogin)
        }
    }
}

struct BenefitView: View {
    let text: String
    let symbolName: String

    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}
#Preview {
    SignUpPromoteView()
}
