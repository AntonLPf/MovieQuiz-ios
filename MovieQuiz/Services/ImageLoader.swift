//
//  ImageLoader.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 30.11.23.
//

import Foundation

protocol ImageLoading {
    func loadImageData(for movie: MostPopularMovie) throws -> Data
}

struct ImageLoader: ImageLoading {
    
    private let networkClient = NetworkClient()
    
    func loadImageData(for movie: MostPopularMovie) throws -> Data {
        try Data(contentsOf: movie.resizedImageURL)
    }
}
