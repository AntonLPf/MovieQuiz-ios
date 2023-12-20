//
//  ImageLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol ImageLoaderProtocol {
    
    func loadImageData(for movie: MostPopularMovie) throws -> Data
    
}
