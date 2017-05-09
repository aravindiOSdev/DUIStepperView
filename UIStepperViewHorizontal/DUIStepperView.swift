//
//  DUIStepperViewHorizontal.swift
//  DUIStepperViewHorizontal
//
//  Created by Dhanasekarapandian Srinivasan on 5/5/17.
//  Copyright © 2017 systameta. All rights reserved.
//

import Foundation
import UIKit


enum StepState : String{
    case Normal = "1"
    case Active = "2"
    case Completed = "3"
}

fileprivate protocol StepViewTappedDelegate{
    func stepTapped(step : Int)
}

class DUIStepView: UIView {
    
    private let tappedRecognizer : UITapGestureRecognizer = UITapGestureRecognizer()
    var config : Dictionary<String,String>?
    var imageViewForState : UIImageView?
    fileprivate var stepViewTappedDelegate :StepViewTappedDelegate?
    var state : StepState! = .Normal{
        didSet{
            switch state! {
            case .Active :
                UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.imageViewForState?.image = UIImage(named: self.config![self.state.rawValue]!)
                    if let image = self.imageViewForState?.image{
                        self.layer.transform = CATransform3DMakeScale(image.size.height / self.frame.size.height, image.size.width / self.frame.size.width, 1)
                    }
                }, completion: { (completed) in
                    
                })
                break
            case .Completed :
                UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    self.imageViewForState?.image = UIImage(named: self.config![self.state.rawValue]!)
                    if let image = self.imageViewForState?.image{
                        self.layer.transform = CATransform3DMakeScale(self.frame.size.height / image.size.height , self.frame.size.width / image.size.width , 1)
                    }
                }, completion: { (completed) in
                    
                })

                break
            case .Normal:
                    UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        self.imageViewForState?.image = nil
                        self.imageViewForState?.backgroundColor = UIColor.lightGray
                        self.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }
                , completion: { (completed) in
                    
                })
                break
            }
        }
    }
    
    override class var layerClass  : AnyClass{
        get{
            return CAShapeLayer.self
        }
    }
    
    init(frame:CGRect, confi : Dictionary<String,String>) {
        super.init(frame: frame)
        self.config = confi
        self.setStepView()
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY) , radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: false)
        (layer as! CAShapeLayer).path = path.cgPath
        tappedRecognizer.addTarget(self, action: #selector(DUIStepView.tapped))
        self.addGestureRecognizer(tappedRecognizer)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStepView()
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY) , radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: false)
        (layer as! CAShapeLayer).path = path.cgPath
        tappedRecognizer.addTarget(self, action: #selector(DUIStepView.tapped))
        self.addGestureRecognizer(tappedRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setStepView()
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY) , radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: false)
        (layer as! CAShapeLayer).path = path.cgPath
    }
    
    private func setStepView(){
        if imageViewForState == nil{
            imageViewForState = UIImageView(frame: frame)
            imageViewForState?.backgroundColor = UIColor.white
            imageViewForState?.layer.cornerRadius = frame.size.height / 2
            if config![self.state.rawValue] != nil
            { imageViewForState?.image = UIImage(named: config![self.state.rawValue]!) }
            else{
                imageViewForState?.image = nil
            imageViewForState?.backgroundColor = UIColor.lightGray
            }
            addSubview(imageViewForState!)
        }
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
    }
    
    func tapped(){
        stepViewTappedDelegate?.stepTapped(step: self.tag)
    }
    
}

class DUIStepperProgressBarView: UIView {
    var color: UIColor!{
        didSet{
//            setNeedsDisplay()
        }
    }
    override class var layerClass : AnyClass{
        get{
            return CAShapeLayer.self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        self.contentMode = .redraw
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x : 0, y : self.bounds.midY))
        path.lineWidth = frame.size.height
        path.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.midY))
        if let _ = color{
            backgroundColor = color
            layer.backgroundColor = color.cgColor
            layer.borderColor = color.cgColor
        }else{
            backgroundColor = UIColor.lightGray
            layer.backgroundColor = UIColor.lightGray.cgColor
            layer.borderColor = UIColor.lightGray.cgColor
        }
        (layer as! CAShapeLayer).path = path.cgPath
    }
    
}

@objc protocol DUIStepperViewDelegate {
    func stepSelected(step : Int)
    func stepViewConfig(step : Int, stepperView: DUIStepperView) -> Dictionary<String,String>
    func noOfSteps() -> Int
}


@IBDesignable class DUIStepperView: UIView , StepViewTappedDelegate{
    
    var configs : Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()
    
    @IBInspectable var noOfSteps : NSNumber! = 2{
        didSet{
            if let _ = stepDelegate{
                stepsView.forEach { (view) in
                    view.removeFromSuperview()
                }
                stepsView.removeAll()
                setUpStepsView()
                for (index,item) in stepsView.enumerated(){
                    item.tag = index
                    self.addSubview(item)
                }
                setNeedsDisplay()
            }
            
        }
    }
    private var numberOfSteps : NSNumber!
    let pad : CGFloat = 32.0
    var progressViewColorTint : UIColor = UIColor.lightGray{
        didSet{
            progressBarView.color = progressViewColorTint
        }
    }
    private var progressBarView : DUIStepperProgressBarView!
    private var stepsView : [DUIStepView] = [DUIStepView]()
    private var equiDistant : CGFloat = 0.0

    var stepDelegate : DUIStepperViewDelegate? {
        didSet{
            if let _ = stepDelegate{
                numberOfSteps = NSNumber(integerLiteral: stepDelegate!.noOfSteps())
                for item in 1...numberOfSteps.intValue{
                    configs.append(stepDelegate!.stepViewConfig(step: item-1, stepperView: self))
                }
                noOfSteps = numberOfSteps
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let _ =  progressBarView{
            progressBarView.removeFromSuperview()
            progressBarView = DUIStepperProgressBarView()
            progressBarView.color = UIColor.lightGray
            progressBarView.setNeedsDisplay()
        }else{
            progressBarView = DUIStepperProgressBarView()
            progressBarView.color = UIColor.lightGray
            progressBarView.setNeedsDisplay()
        }
        self.addSubview(progressBarView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let _ =  progressBarView{
            progressBarView.removeFromSuperview()
            progressBarView = DUIStepperProgressBarView()
            progressBarView.color = UIColor.lightGray
        }else{
            progressBarView = DUIStepperProgressBarView()
            progressBarView.color = UIColor.lightGray
        }
        self.addSubview(progressBarView)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        progressBarView.frame = CGRect(origin: CGPoint(x: pad, y : rect.midY), size: CGSize(width: rect.size.width - (pad * 2), height: 2))
        equiDistant = CGFloat(Int(progressBarView.frame.size.width) / (noOfSteps.intValue - 1))
        progressBarView.color = UIColor.lightGray
        progressBarView.setNeedsDisplay()
        for (index,item) in stepsView.enumerated(){
            if index == 0{
                item.center = CGPoint(x: pad, y: rect.midY)
                item.setNeedsDisplay()
            }else{
                item.center = CGPoint(x: stepsView[index - 1].center.x + equiDistant, y: rect.midY)
                item.setNeedsDisplay()
            }
        }
    }
    
    func updateStatus(stepAt : Int , status : StepState){
        stepsView[stepAt].state = status
    }
    
    func setUpStepsView() {
        for item in 0..<noOfSteps.intValue {
            let view = DUIStepView(frame:CGRect(x: 0, y: 0, width: 21, height: 21), confi : configs[item])
            view.stepViewTappedDelegate = self
            stepsView.append(view)
        }
    }
    
    func stepSelected(step: Int) {
        stepDelegate?.stepSelected(step: (step + 1))
    }
    
    func stepTapped(step: Int) {
        self.stepSelected(step: step)
        for (_,item) in self.stepsView.enumerated(){
            if item.state != .Active && item.tag == step{
               item.state = .Active
            }else{
                item.state = .Normal
            }
        }
    }
    
}
