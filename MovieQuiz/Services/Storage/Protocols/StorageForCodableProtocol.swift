//
//  StorageForCodableProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol StorageForCodableProtocol {
    
    func save(codable: Codable, key: String) throws
    
    func load<T: Codable>(key: String,_ type: T.Type) throws -> Codable
    
}
