//
//  ImagePicker.swift
//  MixUIKitSwiftUI
//
//  Created by wling on 2020/12/25.
//

import SwiftUI

//示例：SwiftUI中展示UIKit
//实现 UIViewControllerRepresentable 协议，makeUIViewController方法负责创建并返回UIKit对象，updateUIViewController方法负责更新UIKit对象

//SwiftUI 与 UIKit 交互：
//1、SwiftUI View 中创建 Coordinator 类，如果UIKit类有Delegate，该类实际上扮演其Delegate，所以需要服从UIKit类Delegate协议并实现协议方法，且在makeUIViewController方法中创建UIKit类时需要设置上delegate
//2、SwiftUI View 中添加UIViewControllerRepresentable协议的 makeCoordinator 方法实现，返回Coordinator对象

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image:UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent:ImagePicker
        
        init(parent:ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            self.parent.image = image
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}
