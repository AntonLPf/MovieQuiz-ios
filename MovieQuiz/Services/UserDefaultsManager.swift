//
//  UserDefaultsManager.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

class UserDefaultsManager {
    
    enum UserDefaultsManagerError: Error, LocalizedError {
        case encodingError
        case failedLoadingData
        
        var errorDescription: String {
            switch self {
            case .encodingError:
                return "Ошибка кодирования"
            case .failedLoadingData:
                return "Ошибка загрузки данных"
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    func save(codable: Codable, key: String) throws {
        guard let data = try? JSONEncoder().encode(codable) else {
            let error = UserDefaultsManagerError.encodingError
            print(error)
            throw error
        }

        userDefaults.set(data, forKey: key)
    }
        
    func load<T: Codable>(key: String,_ type: T.Type) throws -> Codable {
        guard let data = userDefaults.data(forKey: key),
              let loadedResult = try? JSONDecoder().decode(type, from: data) else {
            let error = UserDefaultsManagerError.failedLoadingData
            print(error)
            throw error
        }

        return loadedResult
    }
}
