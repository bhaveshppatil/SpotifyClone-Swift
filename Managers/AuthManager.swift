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
    private var refreshingToken = false
    struct Constants {
        static let client_id = "20a8d9bb77f248308a6e39cf9680fe78"
        static let clientSecret = "361375f2f8f84361a371fcfa80273dc2"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        static let tokenAPI_url = "https://accounts.spotify.com/api/token"
        static let base_url = "https://accounts.spotify.com/"
        static let redirect_url = "https://github.com/bhaveshppatil/SpotifyClone-Swift"
    }
    
    private init(){}
    
    public var signInURL : URL? {
        
        let authURL = "\(Constants.base_url)authorize?response_type=code&client_id:=\(Constants.client_id)&scope:\(Constants.scope)&redirect_uri:\(Constants.redirect_url)"
        return URL(string: authURL)
    }
    
    var isSignIn : Bool {
        return accessToken != nil
    }
    
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken : String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenEXPDate : Date? {
        return UserDefaults.standard.object(forKey: "expirationdate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expDate = tokenEXPDate else { return false}
        let currentDate = Date()
        let min : TimeInterval = 300
        return currentDate.addingTimeInterval(min) >= expDate
    }
    
    public func codeForTokenExchange(
        code : String,
        completion: @escaping ((Bool) -> Void)
    ){
        guard let url  = URL(string: Constants.tokenAPI_url) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_url", value: Constants.redirect_url),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.client_id+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64Str = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64Str)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                      completion(false)
                      return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result : result)
                completion(true)
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withValidToken (
        completion : @escaping (String) -> Void
    ){
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            //Refresh Token
            refreshIFNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIFNeeded(completion : @escaping(Bool) -> Void){
        guard !refreshingToken else{
            return
        }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPI_url) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.client_id+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64Str = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64Str)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,
                  error == nil else {
                      completion(false)
                      return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.cacheToken(result : result)
                completion(true)
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func cacheToken(result : AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
