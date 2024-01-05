//
//  ContainerView.swift
//  OnboardingTask
//
//  Created by Александр Молчан on 4.01.24.
//

import UIKit
import SnapKit

final class ContainerView: UIView, CardViewDelegate {
    var numberOfCardsToShow: Int = 0
    var cardsToBeVisible: Int = 3
    var cardViews = [CardView]()
    var remainingcards: Int = 0
    
    var visibleCards: [CardView] {
        return subviews as? [CardView] ?? []
    }
    var dataSource: CardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        removeAllCardViews()
        guard let dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = dataSource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: dataSource.card(at: i), atIndex: i )
            addCardFrame(cardView: dataSource.card(at: i))
        }
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingcards -= 1
    }
    
    func addCardFrame(cardView: CardView) {
        cardView.frame = cardView.containerView.frame
    }
    
    private func removeAllCardViews() {
        visibleCards.forEach { cardView in
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    func swipeDidEnd(on view: CardView) {
        guard let dataSource else { return }
        if remainingcards > 0 {
            let newIndex = dataSource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: dataSource.card(at: newIndex), atIndex: 2)
            for cardView in visibleCards.reversed() {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    guard let self else { return }
                    cardView.center = self.center
                    self.addCardFrame(cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        } else {
            for cardView in visibleCards.reversed() {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    guard let self else { return }
                    cardView.center = self.center
                    self.addCardFrame(cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func deleteFromArray() {
        
    }
}
