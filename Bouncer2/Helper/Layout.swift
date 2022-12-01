//
//  Layout.swift
//  Bouncer
//
//  Created by Andrew Kestler on 2/9/22.
//

import UIKit
import Foundation


struct SafeArea{
   
    private init(){}
    static func topSafeArea() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as! UIWindowScene
        let window = windowScene.windows.first!
        return window.safeAreaInsets.top
    }
}

extension UIViewController {
    
    
        func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    func configureGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.9).cgColor, UIColor(red: 0.00, green: 0.98, blue: 1, alpha: 0.89).cgColor]
        gradient.locations = [0.5, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        return gradient
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
       
    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) \n", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
       if #available(iOS 11.0, *) {
         return safeAreaLayoutGuide.topAnchor
       }
       return topAnchor
     }

     var safeLeftAnchor: NSLayoutXAxisAnchor {
       if #available(iOS 11.0, *){
         return safeAreaLayoutGuide.leftAnchor
       }
       return leftAnchor
     }

     var safeRightAnchor: NSLayoutXAxisAnchor {
       if #available(iOS 11.0, *){
         return safeAreaLayoutGuide.rightAnchor
       }
       return rightAnchor
     }

     var safeBottomAnchor: NSLayoutYAxisAnchor {
       if #available(iOS 11.0, *) {
         return safeAreaLayoutGuide.bottomAnchor
       }
       return bottomAnchor
     }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView?, yConstant: CGFloat? = 0) {
        guard let view = view else {return}
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
        
    }
    
    func centerXBottom(inView view: UIView, bottomAnchor: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom!).isActive = true
        }else{
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingBottom!).isActive = true
        }
        
    }
    

    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    func centerYright(inView view: UIView?, rightAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingRight: CGFloat = 0, constant: CGFloat = 0) {
        guard let view = view else {return}
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let right = rightAnchor {
            anchor(right: right, paddingRight: paddingRight)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func aspectSetDimensions(height: CGFloat, width: CGFloat) {
        if height > width{
            let ratio: CGFloat = width / height
            let width: CGFloat = .makeHeight(height) * ratio
            let height: CGFloat = .makeHeight(height)
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }else{
            let ratio: CGFloat = height / width
            let height: CGFloat = .makeWidth(width) * ratio
            let width: CGFloat = .makeWidth(width)
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
extension CGSize{
    static func aspectGetSize(height: CGFloat, width: CGFloat) -> CGSize {
        if height > width{
            let ratio: CGFloat = width / height
            let width: CGFloat = .makeHeight(height) * ratio
            let height: CGFloat = .makeHeight(height)
            return CGSize(width: width.rounded(), height: height.rounded())
        }else{
            let ratio: CGFloat = height / width
            let height: CGFloat = .makeWidth(width) * ratio
            let width: CGFloat = .makeWidth(width)
            return CGSize(width: width.rounded(), height: height.rounded())
        }
    }
}

extension UITextField {

    enum PaddingSide {
        
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {
        
       

        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always

        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always

        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension CALayer {
    func addGradienBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }

}
extension UIView{

    func gradientButton(_ buttonText:String, startColor:UIColor, endColor:UIColor) {

        let button:UIButton = UIButton(frame: self.bounds)
        

        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
        self.mask = button

        button.layer.cornerRadius =  button.frame.size.height / 2
        button.layer.borderWidth = 5.0
        button.setTitle(buttonText, for: .normal)
        
    }
}

extension NSAttributedString{
    class func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.poppinsMedium(size: .makeWidth(18))])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.poppinsMedium(size: .makeWidth(15)), .foregroundColor: UIColor.white]))
        return attributedText
        
    }
}

extension CGFloat{
    
    static func makeHeight(_ points: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.height * (CGFloat(points)/CGFloat(896))
    }
    
    static func makeWidth(_ points: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.width * (CGFloat(points)/CGFloat(414))
    }
    
    static func wProportioned(_ points: CGFloat) -> CGFloat {
        return (.makeWidth(414) * points/414).rounded(.towardZero)
    }
    
    static func hProportioned(_ points: CGFloat) -> CGFloat {
        return .makeHeight(896) * points/896
    }
    
    static var midX: CGFloat {
        return UIScreen.main.bounds.midX
    }
    static var maxX: CGFloat {
        return UIScreen.main.bounds.maxX
    }
    
    static var midY: CGFloat {
        return UIScreen.main.bounds.midY
    }
    
    static var maxY: CGFloat {
        return UIScreen.main.bounds.maxY
    }
    
}
enum XY{
    case width
    case height
}
func originalPoints(value: CGFloat, for xy: XY) -> CGFloat{
    
    switch xy{
    case .width:
        return (value / UIScreen.main.bounds.width) * 414
    case .height:
        return (value / UIScreen.main.bounds.height) * 896
    }
}
extension CGRect{
    static func layoutRect(width: CGFloat, height: CGFloat, rectCenter: RectCenter? = nil, padding: Padding? = nil, keepAspect: Bool? = nil) -> CGRect{
        
        
        let size = makeSize(width: width, height: height, keepAspect: keepAspect)
        let height = size.height
        let width = size.width
        guard let rectCenter = rectCenter else {
            guard let padding = padding, padding.anchor.count == 2 else {
                fatalError("you must specify two paddings w/ out a center operation")
            }
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            var count: Int = 0
            for anchor in padding.anchor {
                let paddingValue = padding.padding[count]
                switch anchor{
                case .top:
                    y = paddingValue
                case .bottom:
                    y = .maxY - height - paddingValue
                    print(height)
                case .right:
                    x = .maxX - width - paddingValue
                    print(.maxX - width)
                case .left:
                    x = paddingValue
                
                }
                count += 1
            }
            return CGRect(origin: CGPoint(x: x, y: y), size: size)
        }
        
        switch rectCenter {
        case .centerX:
            guard let padding = padding, let anchor = padding.anchor.first  else { fatalError("Must specify padding for centerX")}
                switch anchor{
                case .top:
                    return CGRect(origin: CGPoint(x: .midX - (width/2), y: padding.padding[0]), size: size)
                case .bottom:
                    return CGRect(origin: CGPoint(x: .midX - (width/2), y: .maxY - height - padding.padding[0]), size: size)
                default:
                    fatalError("You must specify top or bottom for centerX")
                    
                }
            
        case .centerY:
            guard let padding = padding, let anchor = padding.anchor.first else {fatalError("You must specify padding for centerY")}
            switch anchor{
            case .left:
                return CGRect(origin: CGPoint(x: padding.padding[0], y: .midY - (height/2)), size: size)
            case .right:
                print("X: \(.maxX - width - padding.padding[0])")
                print("padding: \(padding.padding[0])")
                return CGRect(origin: CGPoint(x: .maxX - width - padding.padding[0], y: .midY - (height/2)), size: size)
               
            default:
              fatalError("You must specify left or right for centerY")
            }
        case .center:
            return CGRect(x:  .midX - (width/2), y: .midY - (height/2), width: width, height: height)
        }
    }
    
   static func makeSize(width: CGFloat, height: CGFloat, keepAspect: Bool?) -> CGSize{
        if let keepAspect = keepAspect, keepAspect == true {
            if width > height{
                return CGSize(width: .makeWidth(width), height: .makeWidth(width) * height/width)
            }else if height > width{
                return CGSize(width: .makeHeight(height) * width/height, height: .makeHeight(height))
            }else{
                //use width for squares by default, do 80.0001 for height
                return CGSize(width: .makeWidth(width), height: .makeWidth(height))
            }
        }else{
            return CGSize(width: .makeWidth(width), height: .makeHeight(height))
        }
    }
}
enum PaddingAnchor{
    case top
    case bottom
    case right
    case left
}
struct Padding{
    let anchor: [PaddingAnchor]
    let padding: [CGFloat]
    init(anchor: PaddingAnchor..., padding: CGFloat...){
        self.anchor = anchor
        self.padding = padding
    }
}
enum RectCenter{
    case centerX
    case centerY
    case center
}


