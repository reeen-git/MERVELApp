//
//  WebView.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/19.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
   
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
