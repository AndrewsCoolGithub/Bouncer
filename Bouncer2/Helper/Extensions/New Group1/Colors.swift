//
//  Colors.swift
//  Bouncer8321
//
//  Created by Andrew Kestler on 8/3/21.
//


import UIKit
import UIImageColors

extension Array where Element == ColorModel {
    func uiImageColors() -> UIImageColors{
        return UIImageColors(background: .clear, primary: self[0].uiColor(), secondary: self[1].uiColor(), detail: self[2].uiColor())
    }
    
    func uiColors() -> [UIColor]{
        return self.map({$0.uiColor()})
    }
    
    func cgColors() -> [CGColor]{
        return self.map({$0.cgColor()})
    }
}

extension UIColor{
    
    /**
            85 / 255
    */
    class func buttonFill() -> UIColor{
        return UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    }
    
    /**
            150 / 255
    */
    class func greyBorder() -> UIColor{
        return UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    }
    
    /**
            18 / 255
    */
    class func nearlyBlack() -> UIColor{
        return UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
    }
    
    /**
            205 / 255
    */
    class func nearlyWhite() -> UIColor{
        return UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
    }
    
    /**
            235/ 255
    */
    class func offWhite() -> UIColor{
        return UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    /**
            30 / 255
    */
    class func greyColor() -> UIColor{
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
   
    
    /**
            40 / 255
    */
    class func lightGreyColor() -> UIColor{
        return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    }
    
    /**
            75 / 255
    */
    class func lightGreyColor2() -> UIColor{
        
        return UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
    }
    
    
    /**
            60 / 255
    */
    class func buttonGreyColor() -> UIColor{
    
        return UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    }
    
    /**
            r: 255 g: 200 b: 115
    */
    
    class func lightOrange() -> UIColor{
        return UIColor(red: 1, green: 200/255, blue: 115/255, alpha: 1)
    }
   
    
    /**
        r: 0 g: 240 b: 255
    */
    class func blueMinty() -> UIColor{
        return UIColor(red: 0, green: 240/255, blue: 255/255, alpha: 1)
    }
    
    /**
        r: 255 g: 90 b: 90
    */
    class func redColor() -> UIColor{
        return UIColor.init(red: 255/255, green: 90/255, blue: 90/255, alpha: 1)
    }
    
    /**
            200/255
    */
    class func lightGreyText() -> UIColor{
        return UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }
    
    /**
            165/255
    */
    class func darkerGreyText() -> UIColor{
        return UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
    }
    
    class func greyButtonGradientFill() -> [CGColor] {
        var colorArray = [CGColor]()
        colorArray.append(UIColor.init(red: 60/255, green: 60/255, blue: 60/255, alpha: 1).cgColor)
        colorArray.append(UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).cgColor)
        return colorArray
    }
    class func blueGradientBorder() -> [UIColor] {
            var colorArray = [UIColor]()
            colorArray.append(UIColor.init(red: 0, green: 241/255, blue: 259/255, alpha: 1))
            colorArray.append(UIColor.init(red: 108/255, green: 157/255, blue: 228/255, alpha: 1))
            return colorArray
            
        }
    
    class func blueGradientFill() -> [CGColor] {
        var colorArray = [CGColor]()
        colorArray.append(UIColor.init(red: 50/255, green: 70/255, blue: 100/255, alpha: 1).cgColor)
        colorArray.append(UIColor.init(red: 0/255, green: 204/255, blue: 216/255, alpha: 1).cgColor)
        return colorArray
    }
    
    class func shinyGradientFill() -> [CGColor]{
        var colorArray = [CGColor]()
        colorArray.append(UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        colorArray.append(UIColor.init(red: 10, green: 10, blue: 10, alpha: 0.1).cgColor)
        
        
        return colorArray
    }
    
    class func grayGradientFill() -> [CGColor] {
        var colorArray = [CGColor]()
       
        colorArray.append(UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.00).cgColor)
        colorArray.append(UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.77).cgColor)
        colorArray.append(UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.96).cgColor)
        colorArray.append(UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1).cgColor)
       
        return colorArray
    }
}

extension UIColor{
    static func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
      //create UIImage by rendering gradient layer.
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    //get gradient UIcolor from gradient UIImage
    return UIColor(patternImage: image!)
    }
}
extension UIColor {
  /**
   Create a lighter color
   */
  func lighter(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: abs(percentage))
  }
  
  /**
   Create a darker color
   */
  func darker(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: -abs(percentage))
  }
  
  /**
   Try to increase brightness or decrease saturation
   */
  func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      if b < 1.0 {
        let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
        return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
      } else {
        let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
        return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
      }
    }
    return self
  }
    
    

        // Check if the color is light or dark, as defined by the injected lightness threshold.
        // Some people report that 0.7 is best. I suggest to find out for yourself.
        // A nil value is returned if the lightness couldn't be determined.
    
    var brightnessVal: CGFloat {
        let originalCGColor = self.cgColor

        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return 0
        }
        
        guard components.count >= 3 else {
            return 0
        }

        return CGFloat(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
    }
    
}

extension Array where Element == UIColor {
    var brightestColor: UIColor {
        
        var brightness: CGFloat = 0
        var brightestColor: UIColor?
        for color in self {
            let brightnessVal = color.brightnessVal
            if brightnessVal > brightness{
                brightestColor = color
            }
            brightness = brightnessVal
        }
        return brightestColor ?? .white
    }
}
extension UIColor {

    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
