//
//  Protocols.swift
//  OnboardingTask
//
//  Created by Александр Молчан on 4.01.24.
//

import Foundation

protocol CardViewDelegate: AnyObject {
    func swipeDidEnd(on view: CardView)
    func deleteFromArray() 
}

protocol CardViewDataSource: AnyObject {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> CardView
}
