//
//  ViewController.swift
//  HW12-Ios12-OE
//
//  Created by JaloJasela on 18.02.2024.
//

import UIKit

class ViewController: UIViewController {

// MARK: - Conctants

    private enum Color {
        static let backgroundColor: UIColor = .systemGray4
        static let backgroundColorCircleView: UIColor = .systemGray5
        static let workingTimeColor: UIColor = .systemIndigo
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
        circle.layer.borderColor = UIColor.clear.cgColor
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = Color.workingTimeColor
        button.addTarget(self, action: #selector(buttonPlayAction), for: .touchUpInside)
        return button
    }()

    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = animationCircle.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.strokeStart = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Color.workingTimeColor.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        return shapeLayer
    }()
    
    lazy var animationCircle: UIBezierPath = {
        var animationCircle = UIBezierPath()
        let center = CGPoint(x: circleView.frame.width / 2, y: circleView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
       
        animationCircle = UIBezierPath(arcCenter: center, radius: 150, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return animationCircle
    }()
    
// MARK: - Actions

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
        
    private func formatTime() -> String {
        let minutes = Int(durationTime) / 60 % 60
        let seconds = Int(durationTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
        
    @objc func timerAction() {
        durationTime -= 1
        timeLabel.text = "\(formatTime())"

        if durationTime < 1 {
            timer.invalidate()
            playStopButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            playStopButton.tintColor = Color.restTimeColor
            isTimerRunning = false
            if isWorkingTime {
                isWorkingTime = false
                durationTime = TimeDuration.restTime
                timeLabel.text = "\(formatTime())"
                timeLabel.textColor = Color.restTimeColor
                playStopButton.tintColor = Color.restTimeColor
                circleView.layer.borderColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = Color.restTimeColor.cgColor
            } else {
                isWorkingTime = true
                durationTime = TimeDuration.workingTime
                timeLabel.text = "\(formatTime())"
                timeLabel.textColor = Color.workingTimeColor
                playStopButton.tintColor = Color.workingTimeColor
                circleView.layer.borderColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = Color.workingTimeColor.cgColor
            }
        }
    }

    @objc func buttonPlayAction() {
        if isTimerRunning == false {
            isTimerRunning = true
            startTimer()
            playStopButton.setBackgroundImage( UIImage(systemName: "pause"), for: .normal)
            if view.layer.speed == 0 { resumeAnimation(layer: view.layer) } else { animation() }
        } else {
            isTimerRunning = false
            pauseAnimation(layer: view.layer)
            timer.invalidate()
            playStopButton.setBackgroundImage( UIImage(systemName: "play"), for: .normal)
        }
    }
        
    @objc func buttonPauseAction() {
        timer.invalidate()
        buttonPlayAction()
        timeLabel.text = "\(formatTime())"
        playStopButton.setBackgroundImage( UIImage(systemName: "play"), for: .normal)
        playStopButton.tintColor = Color.restTimeColor
    }
    
    private func animation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(durationTime)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func pauseAnimation(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
    }

    private  func resumeAnimation(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0
        layer.beginTime = 0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
      
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.addSublayer(shapeLayer)
    }
    
// MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Color.backgroundColor
    }
    
    private func setupHierarchy() {
        view.addSubViews([circleView, background, timeLabel, playStopButton])
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
            
            timeLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: -40),
            
            playStopButton.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            playStopButton.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: 60),
            playStopButton.widthAnchor.constraint(equalToConstant: 50),
            playStopButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
