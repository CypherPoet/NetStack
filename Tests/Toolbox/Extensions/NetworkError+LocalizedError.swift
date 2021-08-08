//
// File.swift
// 
//
// Created by CypherPoet on 8/6/21.
// ✌️
//

import Foundation
import NetStack



extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        return "NetworkError with code \(code.rawValue): \(code)"
    }
}
