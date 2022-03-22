//
//  APIService.swift
//  SpotifyClone-Swift
//
//  Created by Perennial Macbook on 17/03/22.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private init(){}
    
    public func getCurrentUserPrf(
        completion : @escaping (Result<UserProfile , Error>) -> Void
    ){
        
    }
}
