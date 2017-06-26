//
//  UIImage+QRCode.swift
//  PTPark
//
//  Created by CHEN KAIDI on 19/5/2017.
//
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
    class func qrCode(_ reqStr: String, size: CGSize) -> UIImage? {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        if let data = reqStr.data(using: String.Encoding.utf8) {
            filter!.setValue(data, forKey: "inputMessage")
        }else{
            return nil
        }
        
        if let qrImage = filter!.outputImage {
            
            let scaleX = size.width / qrImage.extent.size.width
            let scaleY = size.height / qrImage.extent.size.height
            
            let resultQrImage = qrImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
            return UIImage(ciImage: resultQrImage)
        }
        return nil
    }
    
    class func barCode(string : String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            //Margin
            filter.setValue(7.00, forKey: "inputQuietSpace")
            filter.setValue(data, forKey: "inputMessage")
            //Scaling
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                let context:CIContext = CIContext.init(options: nil)
                let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
                let rawImage:UIImage = UIImage.init(cgImage: cgImage)
                
                //Refinement code to allow conversion to NSData or share UIImage. Code here:
                //http://stackoverflow.com/questions/2240395/uiimage-created-from-cgimageref-fails-with-uiimagepngrepresentation
                let cgimage: CGImage = (rawImage.cgImage)!
                let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
                let cWidth: size_t  = size_t(cropZone.size.width)
                let cHeight: size_t  = size_t(cropZone.size.height)
                let bitsPerComponent: size_t = cgimage.bitsPerComponent
                //THE OPERATIONS ORDER COULD BE FLIPPED, ALTHOUGH, IT DOESN'T AFFECT THE RESULT
                let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)
                
                let context2: CGContext = CGContext(data: nil, width: cWidth, height: cHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!
                
                context2.draw(cgimage, in: cropZone)
                
                let result: CGImage  = context2.makeImage()!
                let finalImage = UIImage(cgImage: result)
                
                return finalImage
                
            }
        }
        return nil
    }

}
