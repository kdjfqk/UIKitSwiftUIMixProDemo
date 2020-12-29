//
//  ViewController.swift
//  MixUIKitSwiftUI
//
//  Created by wling on 2020/12/25.
//

import UIKit
import SwiftUI

//示例：UIViewController中使用SwiftUI中的View：
//1、正常实现 SwiftUI View
//2、UIViewController中使用 UIHostingController 包装 SwiftUI View
//3、UIHostingController添加到UIViewController.children中，UIHostingController.view添加到UIViewController.view中
//4、对UIHostingController.view添加约束

class ViewController: UIViewController {
    
    var hostVC = UIHostingController(rootView: ContentView())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addChild(hostVC)
        self.view.addSubview(hostVC.view)
        setSwiftUIViewConstraints()
    }
    
    func setSwiftUIViewConstraints() {
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostVC.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            hostVC.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),
            hostVC.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            hostVC.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }


}

