//
//  RockView.swift
//  DevFun
//
//  Created by Abeer Alyaeesh on 12/07/1445 AH.
//

import SwiftUI
import UIKit
import ImageIO

struct RockView: View {
    @State private var isPresented = false
    // To dismiss the view
    @Environment(\.dismiss) private var dismiss
    let myImage = UIImage.gifImageWithName("rock1")
    @State private var buttonTapped = false
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                Color(hex: "0088CA").ignoresSafeArea()
                
                
                VStack{  NavigationLink(destination: ContentView(buttonTapped: buttonTapped)) {
                    EmptyView()
                }
                    VStack{
                        
                        
                        
                        ImageViewWrapper(image:myImage)
                            .frame(width: 200, height: 200)
                        
                    }
                    
                    
                    Text("You Rock! ")
                        .font(
                            Font.custom("SF Pro", size: 46)
                                .weight(.bold)
                        )
                        .foregroundColor(.white)
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .frame(width: 393, height: 852)
            .background(Color(hex: "0088CA").ignoresSafeArea())
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        buttonTapped.toggle()
                        isPresented.toggle()
                        
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .fullScreenCover(isPresented: $isPresented) {
                        ContentView(buttonTapped: buttonTapped)
                    }
                }
            }
        }
    }
}
//    struct GIFView: UIViewRepresentable {
//        var name: String
//
//        func makeUIView(context: Context) -> UIView {
//            let uiView = UIView()
//            let gifImageView = UIImageView()
//            uiView.addSubview(gifImageView)
//
//            // Load and display the GIF
//            if let gifPath = Bundle.main.path(forResource: name, ofType: "gif"),
//               let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
//               let image = UIImage.gifImageWithData(gifData) {
//                gifImageView.image = image
//            }
//
//            return uiView
//        }
//
//        func updateUIView(_ uiView: UIView, context: Context) {
//            // Update logic if needed
//        }
//    }
//
//    #if DEBUG
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//    #endif



#Preview {
    RockView()
}


//import ImageIO


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
switch (lhs, rhs) {
case let (l?, r?):
return l < r
case (nil, _?):
return true
default:
return false
}
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.0
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.0 {
            delay = 0.0
        }
        
        return delay
    }
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
    var a = a
    var b = b
    if b == nil || a == nil {
    if b != nil {
    return b!
    } else if a != nil {
    return a!
    } else {
    return 0
    }
    }

        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
    }

    import SwiftUI
    import UIKit

struct ImageViewWrapper: UIViewRepresentable {
    let image: UIImage?
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = image
    }
}
