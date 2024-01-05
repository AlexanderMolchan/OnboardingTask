//
//  ViewController.swift
//  OnboardingTask
//
//  Created by Александр Молчан on 4.01.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, CardViewDataSource, CardViewDelegate {
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.tintColor = .systemOrange
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.tintColor = .systemOrange
        button.contentHorizontalAlignment = .right
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 30)
        return button
    }()
    
    private var containerView = ContainerView()
    private var cardViewArray = CardView.getData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfiguration()
        addTargets()
    }
    
    private func controllerConfiguration() {
        self.view.backgroundColor = UIColor(red: 0.950, green: 0.950, blue: 0.950, alpha: 1)
        containerView.dataSource = self
        cardViewArray.forEach { view in
            view.controllerDelegate = self
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(400)
            make.width.equalTo(400)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.alpha = 0
        nextButton.alpha = 0
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(260)
        }
    }
    
    private func addTargets() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        buttonRename()
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            self.startButton.alpha = 0
            self.containerView.alpha = 1
        } completion: { [weak self] isFinish in
            guard let self, isFinish else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.nextButton.alpha = 1
            }
        }
    }
    
    private func returnToStart() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            self.containerView.alpha = 0
            self.nextButton.alpha = 0
        } completion: { [weak self] isFinish in
            guard let self, isFinish else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.startButton.alpha = 1
                self.cardViewArray = CardView.getData()
                self.containerView.reloadData()
                self.cardViewArray.forEach { view in
                    view.controllerDelegate = self
                }
            }
        }
    }
    
    @objc private func nextButtonTapped() {
        guard !cardViewArray.isEmpty else {
            returnToStart()
            return
        }
        if cardViewArray.count == 1 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.animatedCardDismiss()
            } completion: { [weak self] isFinish in
                guard  let self, isFinish else { return }
                self.returnToStart()
            }
        } else {
            animatedCardDismiss()
        }
    }
    
    private func animatedCardDismiss() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.cardViewArray[0].center.x -= 500
        } completion: { [weak self] isFinish in
            guard  let self, isFinish else { return }
            self.cardViewArray.remove(at: 0)
            self.buttonRename()
            self.containerView.reloadData()
        }
    }
    
    private func buttonRename() {
        if cardViewArray.count <= 1 {
            nextButton.setTitle("Finish", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.nextButton.backgroundColor = .systemOrange
                self.nextButton.tintColor = .white
            }
        } else {
            nextButton.setTitle("Next", for: .normal)
            nextButton.backgroundColor = .clear
            nextButton.tintColor = .systemOrange
        }
    }
    
}

extension ViewController {
    func deleteFromArray() {
        cardViewArray.remove(at: 0)
        buttonRename()
        containerView.reloadData()
        if cardViewArray.isEmpty {
            returnToStart()
        }
    }
    
    func swipeDidEnd(on view: CardView) {
        
    }
    
    func numberOfCardsToShow() -> Int {
        return cardViewArray.count
    }
    
    func card(at index: Int) -> CardView {
        let card = cardViewArray[index]
        return card
    }
}
                                
