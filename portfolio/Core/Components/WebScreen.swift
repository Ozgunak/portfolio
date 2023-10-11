//
//  WebScreen.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-11.
//

import SwiftUI
import WebKit

struct WebScreen: View {
    let url: String
    var body: some View {
        VStack {
            if let url = URL(string: url) {
                WebView(url: url)
                //                .frame(height: 500)
                    .shadow(radius: 10, y: 5)
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    WebScreen(url: "https://github.com/Ozgunak")
}
