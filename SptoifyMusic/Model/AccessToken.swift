//
//  AccessToken.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 06.12.2024.
//

import Foundation

class AccessToken : Decodable {
    
    var access_token: String = ""
    var token_type: String = ""
    var expires_in: Int = 0
    
}
