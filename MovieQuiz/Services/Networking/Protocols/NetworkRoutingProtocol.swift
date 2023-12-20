//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol NetworkRoutingProtocol {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
    
}
