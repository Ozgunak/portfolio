//
//  TextFieldModifier.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 24)
    }
}
