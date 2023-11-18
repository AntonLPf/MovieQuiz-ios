//
//  StoreProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

protocol StorageProtocol {
    func addNew(record: GameRecord) throws
    
    func loadDb() throws -> DataBase
}
