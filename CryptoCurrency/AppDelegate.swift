//
//  AppDelegate.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 09.06.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let homeViewController = UINavigationController(rootViewController: HomeViewController())
    let chartViewController = UINavigationController(rootViewController: ChartViewController())
    let tabBarController = CustomTabBar()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        APICaller.shared.getAllIcons()
        setupTabBarItems()
    
        tabBarController.viewControllers = [homeViewController, chartViewController]

        let navigationController = UINavigationController(rootViewController: tabBarController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupTabBarItems() {
        homeViewController.tabBarItem.image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)
        homeViewController.tabBarItem.selectedImage = UIImage(named: "homeSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)

        chartViewController.tabBarItem.image = UIImage(named: "chart")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)
        chartViewController.tabBarItem.selectedImage = UIImage(named: "chartSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white)
        
        chartViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -17.55, right: 0)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -17.55, right: 0)
    }
    
}


