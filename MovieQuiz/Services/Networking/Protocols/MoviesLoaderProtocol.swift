//
//  MoviesLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol MoviesLoaderProtocol {
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
    
}
