//
//  ViewController.swift
//  CashFlow
//
//  Created by EMRE ÇOBAN on 26.01.2026.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }


}


#if DEBUG
@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {

    static var previews: some View {
        UIViewControllerPreview {
            ViewController()
        }
        .ignoresSafeArea()
    }
}
#endif
