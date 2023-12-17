//
//  Store.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

class Storage: QuizStorageProtocol {
    
    private let storage: StorageForCodableProtocol!
    
    init(storage: StorageForCodableProtocol = UserDefaultsManager()) {
        self.storage = storage
    }
    
    func addNew(record: GameRecord) throws {
        var db = DataBase(records: [])
        
        if let loadedDb = try? storage.load(key: Keys.dataBase.rawValue, DataBase.self) as? DataBase {
            db = loadedDb
        } else {
            print("Хранилище не найдено. Создание нового хранинища")
        }
        
        db.records.append(record)
        
        try storage.save(codable: db, key: Keys.dataBase.rawValue)
    }
    
    func loadDb() throws -> DataBase {
        guard let db = try storage.load(key: Keys.dataBase.rawValue, DataBase.self) as? DataBase else {
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

extension Storage {
    
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
