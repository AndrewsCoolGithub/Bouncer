
import Foundation
import UIKit

class RippleLayer: CAReplicatorLayer {
    fileprivate var rippleEffect: CALayer?
    private var animationGroup: CAAnimationGroup?
    var rippleRadius: CGFloat = 150.0
    var rippleColor: UIColor = UIColor.white
    var rippleRepeatCount: CGFloat = 10000.0
    var rippleWidth: CGFloat = 8
    
    override init() {
        super.init()
        setupRippleEffect()
        
        repeatCount = Float(rippleRepeatCount)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        rippleEffect?.bounds = CGRect(x: 0, y: 0, width: rippleRadius*2, height: rippleRadius*2)
        rippleEffect?.cornerRadius = rippleRadius
        instanceCount = 3
        instanceDelay = 0.2
    }
    
    func setupRippleEffect() {
        rippleEffect = CALayer()
        rippleEffect?.borderWidth = CGFloat(rippleWidth)
        rippleEffect?.borderColor = rippleColor.cgColor
        rippleEffect?.opacity = 0
        
        addSublayer(rippleEffect!)
    }
    
    func startAnimation() {
        setupAnimationGroup()
        rippleEffect?.add(animationGroup!, forKey: "ripple")
    }
    
    func stopAnimation() {
        rippleEffect?.removeAnimation(forKey: "ripple")
    }
    
    func setupAnimationGroup() {
        let duration: CFTimeInterval = 1.5
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = self.repeatCount
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.0;
        scaleAnimation.toValue = 1.0;
        scaleAnimation.duration = duration
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        let fromAlpha = 1.0
        opacityAnimation.values = [fromAlpha, (fromAlpha * 0.5), 0];
        opacityAnimation.keyTimes = [0, 0.2, 1];
        
        group.animations = [scaleAnimation, opacityAnimation]
        
        animationGroup = group;
        animationGroup!.delegate = self;
    }
}

extension RippleLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let count = rippleEffect?.animationKeys()?.count , count > 0 {
            rippleEffect?.removeAllAnimations()
        }
    }
}

//public extension UIView {
//    
//    func rippleBorder(location:CGPoint, color:UIColor) {
//        rippleBorder(location: location, color: color){}
//    }
//    
//    func rippleBorder(location:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        YRipple.border(view:self, locationInView: location, color: color, then: then)
//    }
//    
//    func rippleFill(location:CGPoint, color:UIColor) {
//        rippleFill(location: location, color: color){}
//    }
//    
//    func rippleFill(location:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        YRipple.fill(view:self, locationInView: location, color: color, then: then)
//    }
//    
//    func rippleStop() {
//        YRipple.stop(view: self)
//    }
//    
//}
//
//
//
//public class YRipple {
//    
//    private static var targetLayer: CALayer?
//    
//    public struct Option {
//        public var borderWidth = CGFloat(5)
//        public var radius = CGFloat(30)   //the size of the circle
//        public var duration = CFTimeInterval(0.5)
//        public var borderColor = UIColor.white
//        public var fillColor = UIColor.clear
//        public var scale = CGFloat(2)
//        public var isRunSuperView = true
//    }
//    
//    public class func option () -> Option {
//        return Option()
//    }
//    
//    public class func run(view:UIView, locationInView:CGPoint, option:YRipple.Option) {
//        run(view:view, locationInView: locationInView, option: option){}
//    }
//    
//    public class func run(view:UIView, locationInView:CGPoint, option:YRipple.Option, then: @escaping ()->() ) {
//        prePreform(view:view, point: locationInView, option: option, isLocationInView: true, then: then)
//    }
//    
//    public class func run(view:UIView, absolutePosition:CGPoint, option:YRipple.Option) {
//        run(view:view, absolutePosition: absolutePosition, option: option){}
//    }
//    
//    public class func run(view:UIView, absolutePosition:CGPoint, option:YRipple.Option, then: @escaping ()->() ) {
//        prePreform(view:view, point: absolutePosition, option: option, isLocationInView: false, then: then)
//    }
//    
//    public class func border(view:UIView, locationInView:CGPoint, color:UIColor) {
//        border(view:view, locationInView: locationInView, color: color){}
//    }
//    
//    public class func border(view:UIView, locationInView:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        var opt = YRipple.Option()
//        opt.borderColor = color
//        prePreform(view: view, point: locationInView, option: opt, isLocationInView: true, then: then)
//    }
//    
//    public class func border(view:UIView, absolutePosition:CGPoint, color:UIColor) {
//        border(view:view, absolutePosition: absolutePosition, color: color){}
//    }
//    
//    public class func border(view:UIView, absolutePosition:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        var opt = YRipple.Option()
//        opt.borderColor = color
//        prePreform(view: view, point: absolutePosition, option: opt, isLocationInView: false, then: then)
//    }
//    
//    public class func fill(view:UIView, locationInView:CGPoint, color:UIColor) {
//        fill(view:view, locationInView: locationInView, color: color){}
//    }
//    
//    public class func fill(view:UIView, locationInView:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        var opt = YRipple.Option()
//        opt.borderColor = color
//        opt.fillColor = color
//        prePreform(view: view, point: locationInView, option: opt, isLocationInView: true, then: then)
//    }
//    
//    public class func fill(view:UIView, absolutePosition:CGPoint, color:UIColor) {
//        fill(view:view, absolutePosition: absolutePosition, color: color){}
//    }
//    
//    public class func fill(view:UIView, absolutePosition:CGPoint, color:UIColor, then: @escaping ()->() ) {
//        var opt = YRipple.Option()
//        opt.borderColor = color
//        opt.fillColor = color
//        prePreform(view: view, point: absolutePosition, option: opt, isLocationInView: false, then: then)
//    }
//    
//    private class func prePreform(view:UIView, point:CGPoint, option: YRipple.Option, isLocationInView:Bool, then: @escaping ()->() ) {
//        
//        
//        let p = isLocationInView ? CGPoint(x:point.x + view.frame.origin.x, y:point.y + view.frame.origin.y) : point
//        if option.isRunSuperView, let superview = view.superview {
//            prePreform(
//                view: superview,
//                point: p,
//                option: option,
//                isLocationInView: isLocationInView,
//                then: then
//            )
//        } else {
//            perform(
//                view: view,
//                point:p,
//                option:option,
//                then: then
//            )
//        }
//    }
//    
//    private class func perform(view:UIView, point:CGPoint, option: YRipple.Option, then: @escaping ()->() ) {
//        UIGraphicsBeginImageContextWithOptions (
//            CGSize(width:(option.radius + option.borderWidth)*2, height:(option.radius + option.borderWidth)*2), false, 3.0)
//        let path = UIBezierPath(
//            roundedRect: CGRect(x:option.borderWidth, y:option.borderWidth, width:option.radius * 2, height:option.radius * 2),
//            cornerRadius: option.radius)
//        option.fillColor.setFill()
//        path.fill()
//        option.borderColor.setStroke()
//        path.lineWidth = option.borderWidth
//        path.stroke()
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        let opacity = CABasicAnimation(keyPath: "opacity")
//        opacity.autoreverses = false
//        opacity.fillMode = CAMediaTimingFillMode.forwards
//        opacity.isRemovedOnCompletion = false
//        opacity.duration = option.duration
//        opacity.fromValue = 1.0
//        opacity.toValue = 0.0
//        
//        let transform = CABasicAnimation(keyPath: "transform")
//        transform.autoreverses = false
//        transform.fillMode = CAMediaTimingFillMode.forwards
//        transform.isRemovedOnCompletion = false
//        transform.duration = option.duration
//        transform.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0 / option.scale, 1.0 / option.scale, 1.0))
//        transform.toValue = NSValue(caTransform3D: CATransform3DMakeScale(option.scale, option.scale, 1.0))
//        
//        var rippleLayer:CALayer? = targetLayer
//        
//        if rippleLayer == nil {
//            rippleLayer = CALayer()
//            view.layer.addSublayer(rippleLayer!)
//            targetLayer = rippleLayer
//            targetLayer?.addSublayer(CALayer())  //Temporary, CALayer.sublayers is Implicitly Unwrapped Optional
//        }
//        
//        DispatchQueue.main.async {
//            [weak rippleLayer] in
//            if let target = rippleLayer {
//                let layer = CALayer()
//                layer.contents = img?.cgImage
//                layer.frame = CGRect(x:point.x - option.radius, y:point.y - option.radius, width:option.radius * 2, height:option.radius * 2)
//                target.addSublayer(layer)
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(option.duration)
//                CATransaction.setCompletionBlock {
//                    layer.contents = nil
//                    layer.removeAllAnimations()
//                    layer.removeFromSuperlayer()
//                    then()
//                }
//                layer.add(opacity, forKey:nil)
//                layer.add(transform, forKey:nil)
//                CATransaction.commit()
//            }
//        }
//    }
//    
//    public class func stop(view:UIView) {
//        
//        guard let sublayers = targetLayer?.sublayers else {
//            return
//        }
//        
//        for layer in sublayers {
//            layer.removeAllAnimations()
//        }
//    }
//}
