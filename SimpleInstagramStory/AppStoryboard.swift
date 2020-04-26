//
//  AppStoryboard.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard : String {
    case Main = "Main"
      
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func view<T: UIViewController>(controllerClass: T.Type) -> T {
        let storyboardID = (controllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        
        return scene
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
}
