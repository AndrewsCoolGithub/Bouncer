//
//  ImageExt.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/25/22.
//

import UIKit

extension UIImageView {
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}
extension UIImage {
    func crop(to:CGSize) -> UIImage {

        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)

        guard let newCgImage = contextImage.cgImage else { return self }

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height

        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height

        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? self
      }
    
    func cropToRect(rect: CGRect!) -> UIImage? {

            let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale);


            guard let imageRef: CGImage = self.cgImage?.cropping(to:scaledRect)
            else {
                return nil
            }

            let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            return croppedImage
        }
    func croppedInRect(rect: CGRect) -> UIImage {
            func rad(_ degree: Double) -> CGFloat {
                return CGFloat(degree / 180.0 * .pi)
            }

            var rectTransform: CGAffineTransform
            switch imageOrientation {
            case .left:
                rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
            case .right:
                rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
            case .down:
                rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
            default:
                rectTransform = .identity
            }
            rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)

            let imageRef = self.cgImage!.cropping(to: rect.applying(rectTransform))
            let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
            return result
        }
    
    func cropToBounds(width: CGFloat, height: CGFloat) -> UIImage {

            let cgimage = self.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

            return image
        }
    
    var middleRect: UIImage? {
        let ratio = 233.0 / 414
        let height = .makeWidth(414) * ratio
//        let y = size.height/2 - height/2
        
        return self.sd_croppedImage(with: CGRect(origin: CGPoint(x: 0, y: 300), size: CGSize(width: .makeWidth(414), height: height)))
    }
    
    var middleSquare: UIImage?{
        let imageRef: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: size.height/2 - .makeWidth(414)/2, width: .makeWidth(414), height: .makeWidth(414)))!
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    var topHalf: UIImage? {
        cgImage?.cropping(
            to: CGRect(
                origin: .zero,
                size: CGSize(width: size.width, height: size.height / 2)
            )
        )?.image
    }
    
    var bottomHalf: UIImage? {
        cgImage?.cropping(
            to: CGRect(
                origin: CGPoint(x: .zero, y: size.height - (size.height/2).rounded()),
                size: CGSize(width: size.width, height: size.height - (size.height/2).rounded())
            )
        )?.image
    }
    var leftHalf: UIImage? {
        cgImage?.cropping(
            to: CGRect(
                origin: .zero,
                size: CGSize(width: size.width/2, height: size.height)
            )
        )?.image
    }
    var rightHalf: UIImage? {
        cgImage?.cropping(
            to: CGRect(
                origin: CGPoint(x: size.width - (size.width/2).rounded(), y: .zero),
                size: CGSize(width: size.width - (size.width/2).rounded(), height: size.height)
            )
        )?.image
    }
    
    func blurredImageWithClippedEdges(inputRadius: CGFloat) -> UIImage? {

            guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {
                return nil
            }
            guard let beginImage = CIImage(image: self) else {
                return nil
            }
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(inputRadius, forKey: "inputRadius")
            guard let output = currentFilter.outputImage else {
                return nil
            }

            // UIKit and UIImageView .contentMode doesn't play well with
            // CIImage only, so we need to back the return UIImage with a CGImage
            let context = CIContext()

            // cropping rect because blur changed size of image

            // to clear the blurred edges, use a fromRect that is
            // the original image extent insetBy (negative) 1/2 of new extent origins
            let newExtent = beginImage.extent.insetBy(dx: -output.extent.origin.x * 0.5, dy: -output.extent.origin.y * 0.5)
            guard let final = context.createCGImage(output, from: newExtent) else {
                return nil
            }
            return UIImage(cgImage: final)

        }
}
extension CGImage {
    var image: UIImage { .init(cgImage: self) }
}
