//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

protocol AlertPresenterProtocol {
    
    var delegate: AlertPreseterDelegate? { get set }

    func show(_ result: AlertModel)
}
