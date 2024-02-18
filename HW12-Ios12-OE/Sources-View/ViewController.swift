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
            static let workingTimeColor: UIColor = .systemOrange
            static let restTimeColor: UIColor = .systemGreen
    }
    
    private enum TimeDuration {
        static let workingTime: Int = 60
        static let restTime: Int = 30
    }
    
    // MARK: - UI
        
    var timer = Timer()
    var durationTime = TimeDuration.workingTime
    
    var isTimerRunning = false
    var isWorkingTime = true
    
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
    
    private lazy var timeLabel: UILabel = {
       let lable = UILabel()
        lable.font = .systemFont(ofSize: 70, weight: .light)
        lable.textColor = Color.workingTimeColor
        lable.text = "\(formatTime())"
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var playStopButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = Color.workingTimeColor
       
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var animationCircle: UIBezierPath = {
        var animationCircle = UIBezierPath()
        let centr = CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        animationCircle = UIBezierPath(arcCenter: centr, radius: 150, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return animationCircle
    }()
    
  
    
    // MARK: - Actions
    
    private func formatTime() -> String {
        let minutes = Int(durationTime) / 60 % 60
        let seconds = Int(durationTime) % 60
        return String(format: "%0:%0", minutes, seconds)
    }
    
    private func animation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(durationTime)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        
    }
    
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

