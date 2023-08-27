//
//  PrototypeVC.swift
//  App Store Buddy
//
//  Created by Yusif Aliyev on 27.08.23.
//

import UIKit

class PrototypeVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }

}
