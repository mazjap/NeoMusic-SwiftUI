//
//  NavController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/16/20.
//

import SwiftUI

struct NavController: UIViewControllerRepresentable {
    typealias Completion = (UINavigationController) -> Void
    private var action: Completion
    
    init(_ action: @escaping Completion = { _ in }) {
        self.action = action
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavController>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavController>) {
        if let navController = uiViewController.navigationController {
            self.action(navController)
        }
    }
}

struct NavController_Previews: PreviewProvider {
    static var previews: some View {
        NavController()
    }
}
