//
//  MessageGetToken.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 06.12.2024.
//

import Foundation

struct MessageGetToken : Encodable {
    let client_id: String
    let client_secret: String
    let grant_type: String = "client_credentials"
}
