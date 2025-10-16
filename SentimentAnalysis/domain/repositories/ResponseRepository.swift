//
//  ResponseRepository.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import Foundation

protocol ResponseRepository {
    func fetchResponses() async throws -> [Response]
}

final class ResponseRepositoryImplementation: ResponseRepository {
    private let responseDataSource: ResponseDataSource
    
    init(responseDataSource: ResponseDataSource) {
        self.responseDataSource = responseDataSource
    }
    
    func fetchResponses() async throws -> [Response] {
        let responses = try await responseDataSource.fetchResponses()
        
        if responses.isEmpty {
            throw ResponseDataSourceError.noResponses
        } else {
            return responses
        }
    }
}
