//
//  TabBarVisibility.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/5/25.
//

import SwiftUI

struct TabBarVisibility: ViewModifier {
    var isHidden: Bool

    func body(content: Content) -> some View {
        content
            .background(TabBarAccessor(isHidden: isHidden))
    }
}

extension View {
    func tabBarHidden(_ hidden: Bool) -> some View {
        self.modifier(TabBarVisibility(isHidden: hidden))
    }
}

fileprivate struct TabBarAccessor: UIViewControllerRepresentable {
    let isHidden: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let tabBarController = controller.view.window?.rootViewController as? UITabBarController {
                tabBarController.tabBar.isHidden = isHidden
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

