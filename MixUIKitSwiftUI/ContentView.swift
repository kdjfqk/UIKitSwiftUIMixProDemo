//
//  ContentView.swift
//  MixUIKitSwiftUI
//
//  Created by wling on 2020/12/25.
//

import SwiftUI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
