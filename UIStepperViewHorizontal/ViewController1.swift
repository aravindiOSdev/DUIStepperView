//
//  ViewController1.swift
//  UIStepperViewHorizontal
//
//  Created by Dhanasekarapandian Srinivasan on 5/5/17.
//  Copyright © 2017 systameta. All rights reserved.
//

import Foundation
import UIKit


class ViewController1: UIViewController {
    
    @IBOutlet var steppers : DUIStepperView!
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.perform(#selector(ViewController1.updateStatus), with: nil, afterDelay: 3.0)
//        self.perform(#selector(ViewController1.reverseStatus), with: nil, afterDelay: 6.0)
    }
    

    
   }
