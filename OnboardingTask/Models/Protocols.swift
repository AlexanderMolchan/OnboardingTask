//
//  Protocols.swift
//  OnboardingTask
//
//  Created by Александр Молчан on 4.01.24.
//

import Foundation

protocol CardViewDelegate {
    func swipeDidEnd(on view: CardView)
    func deleteFromArray() 
}

protocol CardViewDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> CardView
}
