//
//  MovieLoader.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 29.11.23.
//

import Foundation

struct MoviesLoader: MoviesLoaderProtocol {
    
    private let networkClient: NetworkRoutingProtocol
      
    init(networkClient: NetworkRoutingProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesUrl: URL {
        let imdbKey = GlobalConstant.imdbApiKey
        
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/" + imdbKey) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
