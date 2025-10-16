//
//  SentimentAnalysisApp.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import SwiftUI
import SwiftData

@main
struct SentimentAnalysisApp: App {

    var body: some Scene {
        WindowGroup {
            RootView(
                responseRepository: ResponseRepositoryImplementation(
                    responseDataSource: MockResponseDataSource(scorer: Scorer())
                )
            )
        }
    }
}
