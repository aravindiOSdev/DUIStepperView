//
//  ViewController1.swift
//  UIStepperViewHorizontal
//
//  Created by Dhanasekarapandian Srinivasan on 5/5/17.
//  Copyright © 2017 systameta. All rights reserved.
//

import Foundation
import UIKit


class ViewController1: UIViewController,DUIStepperViewDelegate {
    
    @IBOutlet var steppers : DUIStepperView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steppers.stepDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(ViewController1.updateStatus), with: nil, afterDelay: 3.0)
    }
    
    func updateStatus(){
        steppers.updateStatus(stepAt: 2, status: .Completed)
    }
    
    
    func noOfSteps() -> Int {
        return 5
    }
    
    func stepSelected(step: Int) {
        //Navigate to respective controller
    }
    
    func stepViewConfig(step: Int, stepperView: DUIStepperView) ->Dictionary<String,String> {
        var d = Dictionary<String,String>()
        d["2"] = "active_step_image"
        d["3"] = "check_green"
        return d
    }

    
   }
