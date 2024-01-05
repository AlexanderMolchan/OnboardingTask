//
//  CardView.swift
//  OnboardingTask
//
//  Created by Александр Молчан on 4.01.24.
//

import UIKit
import SnapKit

final class CardView: UIView {
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 22)
        label.textColor = .lightGray
        return label
        
    }()
    
    var cardViewImage: UIImage
    var cardViewText: String
    var cardViewCommentLabel: String
    var delegate: CardViewDelegate?
    var controllerDelegate: CardViewDelegate?
    
    init(cardViewImage: UIImage, cardViewText: String, cardViewCommentLabel: String) {
        self.cardViewImage = cardViewImage
        self.cardViewText = cardViewText
        self.cardViewCommentLabel = cardViewCommentLabel
        super.init(frame: .zero)
        configurateCardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getData() -> [CardView] {
        let firstCard = CardView(cardViewImage: UIImage(named: "image1") ?? UIImage(), cardViewText: "Ordina a domicilio senza limiti di distanza. Non èmagia, è Moovenda!", cardViewCommentLabel: "PRONTO?")
        let secondCard = CardView(cardViewImage: UIImage(named: "image2") ?? UIImage(), cardViewText: "Ogni tanto inviamo degli sconti esclusivi tramite notifiche push, ci stai?", cardViewCommentLabel: "PROMOZIONI")
        let thirdCard = CardView(cardViewImage: UIImage(named: "image3") ?? UIImage(), cardViewText: "Per sfruttare al massimo l'app, puoi condividerci la tua posizione?", cardViewCommentLabel: "POSIZIONE")
        return [firstCard, secondCard, thirdCard]
    }
    
    private func configurateCardView() {
        layoutElements()
        makeConstraints()
        addPanGesture()
    }
    
    private func layoutElements() {
        addSubview(containerView)
        imageView.image = cardViewImage
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        containerView.addSubview(imageView)
        label.text = cardViewText
        containerView.addSubview(label)
        commentLabel.text = cardViewCommentLabel
        containerView.addSubview(commentLabel)
        self.bringSubviewToFront(containerView)
    }
    
    private func makeConstraints() {
        let screen = UIScreen.main.bounds
        let screenWidth = screen.width
        let screenHeight = screen.height
        let cardWidth = screenWidth - 40
        let cardHeight = screenHeight * 0.55
        
        self.layer.cornerRadius = 10
        backgroundColor = .white
        
        self.snp.makeConstraints { make in
            make.height.equalTo(cardHeight)
            make.width.equalTo(cardWidth)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview().inset(80)
        }
        
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1/1, constant: 0))
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).inset(-30)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addPanGesture() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureAction)))
    }
    
    
    @objc private func gestureAction(sender: UIPanGestureRecognizer) {
        guard let cardView = sender.view as? CardView else { return }
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        cardView.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        switch sender.state {
            case .ended:
                if cardView.center.x > 300 {
                    delegate?.swipeDidEnd(on: cardView)
                    controllerDelegate?.deleteFromArray()
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let self else { return }
                        cardView.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                        cardView.alpha = 0
                        self.layoutIfNeeded()
                    }
                    return
                    
                } else if cardView.center.x < 20 {
                    delegate?.swipeDidEnd(on: cardView)
                    controllerDelegate?.deleteFromArray()
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let self else { return }
                        cardView.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                        cardView.alpha = 0
                        self.layoutIfNeeded()
                    }
                    return
                }
                
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self else { return }
                    cardView.transform = .identity
                    cardView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                    self.layoutIfNeeded()
                }
            default: break
        }
    }
    
}
