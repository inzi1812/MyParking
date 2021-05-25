//
//  RootViewController.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-24.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController
    
    
    init() {
          self.current = SplashViewController()
          super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        current.view.frame = view.bounds
        add(current)
        
        // Do any additional setup after loading the view.
    }
    


    func switchToLoginPage()
    {
        let loginVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        let nav = UINavigationController(rootViewController: loginVC)
        nav.view.frame = self.view.frame
        
        add(nav)
        current.remove()
        
        current = nav
    }

    
    func switchToMainScreen()
    {
        
        
        let tabBarController = UITabBarController()
        
        let listVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "parkingList_VC") as! ParkingListTableViewController
        
        
        let nav1 = UINavigationController(rootViewController: listVC)
        
        
        let profileVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        
        let nav2 = UINavigationController(rootViewController: profileVC)
        
        
        tabBarController.viewControllers = [nav1,nav2]

        tabBarController.view.frame = self.view.frame
        
        
        nav1.tabBarItem = UITabBarItem(title: "Parkings", image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        add(tabBarController)

        current.remove()

        current = tabBarController
    }
    
    func resetUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: "email")
        
    }
    
    func signOut()
    {
        resetUserDefaults()
        DBHelper.resetUser()
        switchToLoginPage()
    }
    
}
