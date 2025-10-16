//
//  Scorer.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import Foundation
import NaturalLanguage // NLP

struct MyScore {
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    
    func score(_ text: String) -> Double {
        var sentimentScore: Double = 0.0
        tagger.string = text
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .paragraph,
            scheme: .sentimentScore
        ) { tag, _ in
            if
                let sentiment = tag?.rawValue,
                let score = Double(sentiment)
            {
                sentimentScore = score
            }
            
            return false
        }
        
        return sentimentScore
    }
    
    // TODO: refactor
    func score(_ text: String) async -> Double {
        var sentimentScore: Double = 0.0
        tagger.string = text
        
        let didEnumerateTags: Bool = await withCheckedContinuation { continuation in
            tagger.enumerateTags(
                in: text.startIndex..<text.endIndex,
                unit: .paragraph,
                scheme: .sentimentScore
            ) { tag, _ in
                if
                    let sentiment = tag?.rawValue,
                    let score = Double(sentiment)
                {
                    sentimentScore = score
                }
                
                continuation.resume(returning: false)
                return false
            }
        }
        
        return sentimentScore
    }
}
