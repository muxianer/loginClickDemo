import UIKit

class ElasticView: UIView {
    
    private let topControlPointView = UIView()
    private let leftControlPointView = UIView()
    private let bottomControlPointView = UIView()
    private let rightControlPointView = UIView()
    
    private let elasticShape = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponents()
    }
    
    private func setupComponents() {
        elasticShape.fillColor = backgroundColor?.CGColor
        elasticShape.path = UIBezierPath(rect: self.bounds).CGPath
        layer.addSublayer(elasticShape)
        
        for controlPoint in [topControlPointView, leftControlPointView,
            bottomControlPointView, rightControlPointView] {
                addSubview(controlPoint)
                controlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        }
        
        positionControlPoints()
        
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
    }
    
    private func positionControlPoints(){
        topControlPointView.center = CGPoint(x: bounds.midX, y: 0.0)
        leftControlPointView.center = CGPoint(x: 0.0, y: bounds.midY)
        bottomControlPointView.center = CGPoint(x:bounds.midX, y: bounds.maxY)
        rightControlPointView.center = CGPoint(x: bounds.maxX, y: bounds.midY)
    }
    
    private func bezierPathForControlPoints()->CGPathRef {
        
        let path = UIBezierPath()
        
        
        let top = topControlPointView.layer.presentationLayer().position
        let left = leftControlPointView.layer.presentationLayer().position
        let bottom = bottomControlPointView.layer.presentationLayer().position
        let right = rightControlPointView.layer.presentationLayer().position
        
        let width = frame.size.width
        let height = frame.size.height
        
        
        path.moveToPoint(CGPointMake(0, 0))
        path.addQuadCurveToPoint(CGPointMake(width, 0), controlPoint: top)
        path.addQuadCurveToPoint(CGPointMake(width, height), controlPoint:right)
        path.addQuadCurveToPoint(CGPointMake(0, height), controlPoint:bottom)
        path.addQuadCurveToPoint(CGPointMake(0, 0), controlPoint: left)
        
        
        return path.CGPath
    }
    
    private lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: Selector("updateLoop"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        return displayLink
        }()
    
    func updateLoop() {
        elasticShape.path = bezierPathForControlPoints()
    }
    
    private func startUpdateLoop() {
        displayLink.paused = false
    }
    
    private func stopUpdateLoop() {
        displayLink.paused = true
    }
    
    @IBInspectable var overshootAmount : CGFloat = 10
    
    func animateControlPoints() {
        
        let overshootAmount = self.overshootAmount
        
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5,
            options: nil, animations: {
                
                self.topControlPointView.center.y -= overshootAmount
                self.leftControlPointView.center.x -= overshootAmount
                self.bottomControlPointView.center.y += overshootAmount
                self.rightControlPointView.center.x += overshootAmount
            },
            completion: { _ in
                
                UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5,
                    options: nil, animations: {
                        
                        self.positionControlPoints()
                    },
                    completion: { _ in
                        
                        self.stopUpdateLoop()
                })
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        startUpdateLoop()
        animateControlPoints()
    }
    
    override var backgroundColor: UIColor? {
        willSet {
            if let newValue = newValue {
                elasticShape.fillColor = newValue.CGColor
                super.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    
}