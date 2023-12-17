//
//  QuizStorage.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

class QuizStorage: QuizStorageProtocol {
    
    private let storage: StorageForCodableProtocol!
    
    init(storage: StorageForCodableProtocol = UserDefaultsManager()) {
        self.storage = storage
    }
    
    func addNew(record: GameRecord) throws {
        var db = QuizDataBase(records: [])
        
        if let loadedDb = try? storage.load(key: Keys.dataBase.rawValue, QuizDataBase.self) as? QuizDataBase {
            db = loadedDb
        } else {
            print("Хранилище не найдено. Создание нового хранинища")
        }
        
        db.records.append(record)
        
        try storage.save(codable: db, key: Keys.dataBase.rawValue)
    }
    
    func loadDb() throws -> QuizDataBase {
        guard let db = try storage.load(key: Keys.dataBase.rawValue, QuizDataBase.self) as? QuizDataBase else {
            let error = StoreError.failedToLoadDb
            print(error)
            throw StoreError.failedToLoadDb
        }
        return db
    }
    
    private enum Keys: String {
        case dataBase
    }
    
}

extension QuizStorage {
    
    enum StoreError: LocalizedError {
        case failedToSave
        case failedToLoadDb
        
        var errorDescription: String {
            switch self {
            case .failedToSave:
                return "Ошибка Сохранения данных"
            case .failedToLoadDb:
                return "Ошибка загрузки данных"
            }
        }
    }
}
