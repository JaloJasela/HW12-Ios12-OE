//
//  ViewController.swift
//  HW12-Ios12-OE
//
//  Created by IMac on 18.02.2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Conctants

        private enum Color {
            static let backgroundColor: UIColor = .systemGray4
            static let backgroundColorCircleView: UIColor = .systemGray5
    }
    
    // MARK: - UI
        
        var timer = Timer()
    
    private lazy var background: UIImageView = {
        let image = UIImage(named: "tomato")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var circleView: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 150
        circle.layer.borderWidth = 25
        circle.backgroundColor = Color.backgroundColorCircleView
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    // MARK: - Actions
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        
    }
    
    // MARK: - Setups
        
        private func setupView() {
            view.backgroundColor = Color.backgroundColor
        }
        
        private func setupHierarchy() {
            view.addSubViews([circleView, background, ])
        }

        private func setupLayout() {
            NSLayoutConstraint.activate([
                background.heightAnchor.constraint(equalToConstant: 150),
                background.widthAnchor.constraint(equalToConstant: 150),
                background.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                background.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                circleView.widthAnchor.constraint(equalToConstant: 300),
                circleView.heightAnchor.constraint(equalToConstant: 300),
            ])
        }
}

