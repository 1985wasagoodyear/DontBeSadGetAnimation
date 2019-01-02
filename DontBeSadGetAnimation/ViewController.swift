//
//  ViewController.swift
//  DontBeSadGetAnimation
//
//  Created by Kevin Yu on 1/2/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSegmentedControl()
        self.setupImageView()
    }
    
    // MARK: - Setup Methods
    
    func setupSegmentedControl() {
        let seg = self.segmentedControl!
        seg.selectedSegmentIndex = -1
        seg.removeAllSegments()
        
        seg.insertSegment(withTitle: "Spin", at: 0, animated: false)
        seg.insertSegment(withTitle: "Fade", at: 1, animated: false)
        seg.insertSegment(withTitle: "Bounce", at: 2, animated: false)
        seg.insertSegment(withTitle: "Bounce+Spin", at: 3, animated: false)
        seg.insertSegment(withTitle: "Spin+Fade", at: 4, animated: false)
    }
    
    func setupImageView() {
        // load the image
        let image = UIImage(named: "updog.jpg")!
        
        // set up the imageView's image and size
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 0, y: 0,
                                      width: image.size.width / 2.5, height: image.size.height / 2.5)
        
        // add the programmatic UIImageView to the view and
        // center it
        self.view.addSubview(self.imageView)
        self.imageView.center = self.view.center
    }

    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.spin()
        case 1:
            self.fade()
        case 2:
            self.bounce()
        case 3:
            self.bounceAndSpin()
        default:
            self.spinAndFade()
        }
        sender.selectedSegmentIndex = -1
    }
    
    // MARK: - Animations
    
    func spinAnimation(_ duration: CGFloat) -> CABasicAnimation {
        let spinA = CABasicAnimation(keyPath: "transform.rotation")
        spinA.duration = CFTimeInterval(duration)
        spinA.toValue = .pi * 2.0
        return spinA
    }
    
    func spin() {
        let spinA = self.spinAnimation(2.0)
        self.imageView.layer.add(spinA,
                                 forKey: "spinAnimation")
    }
    func fade() {
        let fadeA = CAKeyframeAnimation(keyPath: "opacity")
        fadeA.duration = 3.0
        fadeA.values = [1.0, 0.0, 1.0, 0.0, 1.0]
        fadeA.keyTimes = [0.0, 0.50, 0.75, 0.90, 1.0]
        
        self.imageView.layer.add(fadeA,
                                 forKey: "blinkyAnimation")
    }
    func bounce() {
        let startPos = 0.0
        let height = self.imageView.frame.size.height
        
        let bounceA = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceA.duration = 5.0
        bounceA.values = [startPos, startPos - 10.0,
                          startPos, startPos - 30.0,
                          startPos, -height,
                          startPos, -height - 30.0,
                          startPos, startPos - 30.0,
                          startPos, startPos - 10.0,
                          startPos]
        var keyTimes = [NSNumber]()
        let size = Double(bounceA.values!.count)
        for i in 0..<bounceA.values!.count {
            keyTimes.append(NSNumber(value: (Double(i) * 1.0)/size))
        }
        bounceA.keyTimes = keyTimes // can be omitted, will make linear keytimes
        
        self.imageView.layer.add(bounceA,
                                 forKey: "bounceAnimation")
    }
    func bounceAndSpin() {
        let duration = 3.0
        let group = CAAnimationGroup()
        
        // spinning animation
        let spinA = CABasicAnimation(keyPath: "transform.rotation")
        spinA.duration = duration
        spinA.toValue = .pi * 2.0
        
        // bouncing animation
        let startPos = 0.0
        let height = self.imageView.frame.size.height
        let bounceA = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceA.duration = duration
        bounceA.values = [startPos, startPos - 10.0,
                          startPos, startPos - 30.0,
                          startPos, -height,
                          startPos, -height - 30.0,
                          startPos, startPos - 30.0,
                          startPos, startPos - 10.0,
                          startPos]
        
        group.duration = duration
        group.animations = [spinA, bounceA]
        
        self.imageView.layer.add(group, forKey: "spinningAndBouncing")
    }
    
    func spinAndFade() {
        let duration = 3.0
        let group = CAAnimationGroup()
        
        // spinning animation
        let spinA = CABasicAnimation(keyPath: "transform.rotation")
        spinA.duration = duration
        spinA.toValue = .pi * 2.0
        
        // fading animation
        let fadeA = CAKeyframeAnimation(keyPath: "opacity")
        fadeA.duration = duration
        fadeA.values = [1.0, 0.0, 1.0, 0.0, 1.0]
        fadeA.keyTimes = [0.0, 0.50, 0.75, 0.90, 1.0]
        
        group.duration = duration
        group.animations = [spinA, fadeA]
        
        self.imageView.layer.add(group, forKey: "spinningAndFadingAnimation")
    }
    
}

