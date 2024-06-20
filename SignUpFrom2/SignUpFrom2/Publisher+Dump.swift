//
//  Publisher+Dump.swift
//  SignUpFrom2
//
//  Created by 어재선 on 6/20/24.
//

import Foundation
import Combine

extension Publisher {
    func dump() -> AnyPublisher<Self.Output, Self.Failure> {
        handleEvents(receiveSubscription: { value in
            Swift.dump(value)
        }, receiveCompletion: { value in
            Swift.print(value)
            Swift.dump(value)
        }
        
        )
        .eraseToAnyPublisher()
    }
}
