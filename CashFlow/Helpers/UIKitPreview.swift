//
//  UIKitPreview.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

// ViewController için Preview
#if DEBUG
import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {

    let builder: () -> ViewController

    init(_ builder: @escaping () -> ViewController) {
        self.builder = builder
    }

    func makeUIViewController(context: Context) -> ViewController {
        builder()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

extension ProcessInfo {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
#endif



// UITableViewCell için Preview
#if DEBUG
import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {

    let builder: () -> View

    init(_ builder: @escaping () -> View) {
        self.builder = builder
    }

    func makeUIView(context: Context) -> View {
        builder()
    }

    func updateUIView(_ uiView: View, context: Context) {}
}
#endif

