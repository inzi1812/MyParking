//
//  Extensions.swift
//  MyParking
//
//  Created by RD on 18/05/21.
//

import UIKit

extension String {
    
    var isAlphanumeric: Bool {
            return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
        }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidCarPlateNumber() -> Bool {
       
        if !isAlphanumeric
        {
            return false
        }
        
        if(self.count >= 2 && self.count <= 8){
            
            return true
        }
        
        else {
            return false
        }
    }
    
    func isValidBuildingCode() -> Bool
    {
        return (isAlphanumeric && self.count == 5)
    }
    
    func isValidHostSuiteNum() -> Bool
    {
        if !isAlphanumeric
        {
            return false
        }
        
        if(self.count >= 2 && self.count <= 5){
            
            return true
        }
        
        else {
            return false
        }
    }
}


extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIViewController {

    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return nil }
         return delegate
    }
    
    var SceneRootController : RootViewController
    {
        return sceneDelegate?.window?.rootViewController as! RootViewController
    }
}
