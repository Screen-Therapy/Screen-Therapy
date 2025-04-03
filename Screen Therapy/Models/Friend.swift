//
//  Friend.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/2/25.
//

struct Friend: Identifiable, Decodable {
    var userId: String
    var username: String
    
    var id: String { userId }
}

