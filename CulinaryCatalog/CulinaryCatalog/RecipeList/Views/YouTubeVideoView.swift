//
//  YouTubeVideoView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import AVKit
import SwiftUI
import WebKit

struct YouTubeVideoView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }

        let request = URLRequest(url: youtubeURL)
        uiView.load(request)
    }
}

#Preview {
    YouTubeVideoView(videoID: "1ahpSTf_Pvk")
}
