//
//  ClassifyingResult.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import Combine
import SoundAnalysis

final class ClassifyingResult: NSObject, SNResultsObserving {
    private let subject: PassthroughSubject<SNClassificationResult, Error>
    
    init(subject: PassthroughSubject<SNClassificationResult, Error>) {
        self.subject = subject
    }
    
    func request(_ request: SNRequest,
                 didFailWithError error: Error) {
        subject.send(completion: .failure(error))
    }

    
    func requestDidComplete(_ request: SNRequest) {
        subject.send(completion: .finished)
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        if let classificationResult = result as? SNClassificationResult {
            subject.send(classificationResult)
        }
    }
}
