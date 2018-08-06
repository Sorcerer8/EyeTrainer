//
//  TrainViewController.swift
//  EyesTrainer2
//
//  Created by Dzmitry Shymanski on 06/08/2018.
//  Copyright © 2018 Dzmitry Shymanski. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {

    private static let minFontSize:CGFloat = 16.0
    private static let maxFontSize:CGFloat = 100.0
    private static let fontStepPerSecond:CGFloat = 22.0
    
    @IBOutlet var textLabel: UILabel!
    
    private var isAnimationUpToDown = true
    private var animationTimer:Timer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textLabel.font = self.textLabel.font.withSize(type(of: self).maxFontSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.animationTimer == nil {
            
            let fontsDelta:CGFloat = (type(of: self).maxFontSize - type(of: self).minFontSize)
            let animationDuration:TimeInterval = TimeInterval(fontsDelta / type(of: self).fontStepPerSecond)
            let timerInterval:TimeInterval = max(TimeInterval(animationDuration / TimeInterval(fontsDelta)), 1 / 60)
            
            self.animationTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
                
                self.animateNextStep()
            })
        }
    }
    
    private func animateFontFromUpToDown(withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration, animations: {
            
            self.textLabel.font = self.textLabel.font.withSize(type(of: self).minFontSize)
            
        }, completion: completion)
    }
    
    private func animateFontFromDownToUp(withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
    
        UIView.animate(withDuration: duration, animations: {
            
            self.textLabel.font = self.textLabel.font.withSize(type(of: self).maxFontSize)
            
        }, completion: completion)
    }
    
    private func startNextAnimation() {
        
        let animationDuration:TimeInterval = TimeInterval((type(of: self).maxFontSize - type(of: self).minFontSize) / type(of: self).fontStepPerSecond)
        
        if self.isAnimationUpToDown {
            
            self.isAnimationUpToDown = false
            
            self.animateFontFromDownToUp(withDuration: animationDuration) { (result) in
                
                DispatchQueue.main.async {
                    
                    self.startNextAnimation()
                }
            }
        }
        else {
            
            self.isAnimationUpToDown = true
            
            self.animateFontFromUpToDown(withDuration: animationDuration) { (result) in
                
                DispatchQueue.main.async {
                    
                    self.startNextAnimation()
                }
            }
        }
    }
    
    private func animateNextStep() {
        
        if self.isAnimationUpToDown && self.textLabel.font.pointSize - 1 < type(of: self).minFontSize {
            
            self.isAnimationUpToDown = false
        }
        else if self.isAnimationUpToDown == false && self.textLabel.font.pointSize + 1 > type(of: self).maxFontSize {
            
            self.isAnimationUpToDown = true
        }
        
        if self.isAnimationUpToDown {
            
            self.textLabel.font = self.textLabel.font.withSize(self.textLabel.font.pointSize - 1)
        }
        else {
            
            self.textLabel.font = self.textLabel.font.withSize(self.textLabel.font.pointSize + 1)
        }
    }
}

