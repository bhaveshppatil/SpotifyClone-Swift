//
//  AuthManager.swift
//  SpotifyClone-Swift
//
//  Created by Perennial Macbook on 17/03/22.
//

import Foundation
import FileProvider


final class AuthManager{
    static let shared = AuthManager()
    
    struct Constants {
        static let client_id = "20a8d9bb77f248308a6e39cf9680fe78"
        static let clientSecret = "361375f2f8f84361a371fcfa80273dc2"
        static let scope = "user-read-private"
        static let base_url = "https://accounts.spotify.com/"
        static let redirect_url = "https://github.com/bhaveshppatil/SpotifyClone-Swift"
    }
    
    private init(){}
    
    public var signInURL : URL? {
        
        let authURL = "\(Constants.base_url)authorize?response_type=code&client_id:=\(Constants.client_id)&scope:\(Constants.scope)&redirect_uri:\(Constants.redirect_url)"
        return URL(string: authURL)
    }
    
    var isSignIn : Bool {
        return false
    }
    
    private var accessToken : String? {
        return nil
    }
    
    private  var tokenEXPDate : Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    public func codeForTokenExchange(code : String, completion: @escaping ((Bool) -> Void)){
        
    }
    
    public func refreshToken (){
        
    }
    public func cacheToken(){
        
    }
}
