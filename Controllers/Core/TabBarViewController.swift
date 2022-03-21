//
//  TabbarViewController.swift
//  SpotifyClone-Swift
//
//  Created by Perennial Macbook on 17/03/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVc = HomeViewController()
        let searchVc = SearchViewController()
        let libraryVc = LibraryViewController()
        
        homeVc.title = "Home"
        searchVc.title = "Search"
        libraryVc.title = "Library"
        
        homeVc.navigationItem.largeTitleDisplayMode = .always
        searchVc.navigationItem.largeTitleDisplayMode = .always
        libraryVc.navigationItem.largeTitleDisplayMode = .always
        
        let nv1 = UINavigationController(rootViewController: homeVc)
        let nv2 = UINavigationController(rootViewController: searchVc)
        let nv3 = UINavigationController(rootViewController: libraryVc)
        
        nv1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nv2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nv3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        nv1.navigationBar.prefersLargeTitles = true
        nv2.navigationBar.prefersLargeTitles = true
        nv3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nv1, nv2,nv3], animated: false)

    }
}
