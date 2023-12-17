//
//  ImageLoader.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 30.11.23.
//

import Foundation

protocol ImageLoaderProtocol {
    
    func loadImageData(for movie: MostPopularMovie) throws -> Data
    
}

struct ImageLoader: ImageLoaderProtocol {
    
    private let networkClient = NetworkClient()
    
    func loadImageData(for movie: MostPopularMovie) throws -> Data {
        try Data(contentsOf: movie.resizedImageURL)
    }
}
