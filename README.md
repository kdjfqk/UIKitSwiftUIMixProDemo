# UIKitSwiftUIMixProDemo

Demo实现了[Using coordinators to manage SwiftUI view controllers](https://www.hackingwithswift.com/books/ios-swiftui/using-coordinators-to-manage-swiftui-view-controllers)内容，展示了在UIKit中嵌入SwiftUI View，以及 SwiftUI View 中嵌入UIKit 如何实现


### 一、UIViewController中使用SwiftUI中的View

##### 关键点：**通过UIHostingController类包装View**

##### 实现步骤
   1. 正常实现 SwiftUI View
   2. UIViewController中使用 UIHostingController 包装 SwiftUI View
   3. UIHostingController添加到UIViewController.children中，UIHostingController.view添加到UIViewController.view中
   4. 对UIHostingController.view添加约束


##### 示例代码
```
class ViewController: UIViewController {
    
    var hostVC = UIHostingController(rootView: ContentView())	//ContentView即为要嵌入的SwiftUI View

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
```



### 二、SwiftUI View 中嵌入 UIKit

##### 关键点：**UIViewControllerRepresentable协议 和 Coordinator类，UIViewControllerRepresentable负责展示和更新UIKit对象，Coordinator作为UIKit对象的Delegate与SwiftUI进行交互**

##### 实现步骤
   1. SwiftUI中定义包装UIKit对象的struct类型(暂且叫做 UIKitWrapper)，并实现 UIViewControllerRepresentable 协议，协议方法makeUIViewController负责创建并返回UIKit对象，协议方法updateUIViewController负责更新UIKit对象
   2. 在 UIKitWrapper 内创建内嵌的 Coordinator 类，如果包装的UIKit类有Delegate，则Coordinator需要服从UIKit类Delegate协议并实现协议方法，且在makeUIViewController方法中创建UIKit类时需要设置上delegate
   3. UIKitWrapper 中添加UIViewControllerRepresentable协议的 makeCoordinator 方法实现，返回Coordinator对象
   4. 外部可以像使用其他SwiftUI View一样 来使用 UIKitWrapper

##### 示例代码
```
//定义UIKit包装类型：ImagePicker
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
    
    //定义内嵌的 Coordinator 类
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


//使用 ImagePicker
struct ContentView: View {
    
    @State var isShow = false
    @State var image: Image?
    @State var inputImg:UIImage?
    
    var body: some View {
        VStack{
            Text("Hello, World!")
            image?
                .resizable()
                .scaledToFit()
            Button("show") {
                self.isShow = true
            }
        }.sheet(isPresented: $isShow, onDismiss: loadImage, content: {
            ImagePicker(image: $inputImg)
        })
    }
    
    func loadImage() {
        guard let inputImage = inputImg else { return }
        image = Image(uiImage: inputImage)
    }
}
```
