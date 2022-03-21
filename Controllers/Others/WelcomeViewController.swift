//
//  WelcomeViewController.swift
//  SpotifyClone-Swift
//
//  Created by Perennial Macbook on 17/03/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemRed
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didSignInTap),for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width - 40 ,
            height: 50)
    }
    
    @objc func didSignInTap(){
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func handleSignIn (success : Bool){
        
    }
}
