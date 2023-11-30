//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 29.11.23.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
