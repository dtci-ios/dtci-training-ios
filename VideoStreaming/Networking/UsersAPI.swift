//
//  UsersAPI.swift
//  VideoStreaming
//
//  Created by Julian Llorensi on 15/10/2019.
//  Copyright © 2019 ESPN. All rights reserved.
//

import Foundation

class UsersAPI : NetworkManager {
    var request: String = "https://api.twitch.tv/helix/users"
    
    func fetchUsers(userId: String, completion: @escaping (Result<[User], APIError>) -> Void) {
        let params: [String:Any] = ["id":userId]
        fetchData(request: request, parameters: params, completion: completion)
    }
}
