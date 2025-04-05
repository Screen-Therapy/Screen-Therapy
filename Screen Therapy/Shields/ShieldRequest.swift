//
//  ShieldModel.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/5/25.
//

import Foundation

struct ShieldRequest: Codable {
    let ownerUserId: String
    let createdByUserId: String
    let appGroupName: String
    let blockType: String
    let challengeType: String
    let totalDurationMin: Int
    let startTime: String? // ISO8601 or nil
    let endTime: String?   // ISO8601 or nil
    let repeatDays: [String]
    let quote: String?
    let icon: String
    let primaryColor: String
    let secondaryColor: String
    let reason: String?
    let status: String
    let createdAt: String // backend will likely overwrite this, but required to avoid error
}
