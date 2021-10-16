//
//  ProgressRing.swift
//  ProgressView
//
//  Created by incetro on 10/16/21.
//

import UIKit

// MARK: - ProgressRing

/// A fillable progress ring
open class ProgressRing: UIView {

    // MARK: - Properties

    /// Sets the line width for progress ring and groove ring
    public var lineWidth: CGFloat = 7 {
        didSet {
            ringWidth = lineWidth
            grooveWidth = lineWidth
        }
    }

    /// The line width of the progress ring
    public var ringWidth: CGFloat = 7 {
        didSet {
            ringLayer.lineWidth = ringWidth
        }
    }

    /// The line width of the groove ring
    public var grooveWidth: CGFloat = 7 {
        didSet {
            grooveLayer.lineWidth = grooveWidth
        }
    }

    /// The first gradient color
    public var startColor: UIColor = .systemPink {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }

    /// The second gradient color
    public var endColor: UIColor = .systemRed {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }

    /// The groove color in which the fillable ring resides
    public var grooveColor: UIColor = UIColor.systemGray.withAlphaComponent(0.2) {
        didSet {
            grooveLayer.strokeColor = grooveColor.cgColor
        }
    }

    /// The start angle of the ring to begin drawing
    public var startAngle: CGFloat = -.pi / 2 {
        didSet {
            ringLayer.path = ringPath()
        }
    }

    /// The end angle of the ring to end drawing
    public var endAngle: CGFloat = 1.5 * .pi {
        didSet {
            ringLayer.path = ringPath()
        }
    }

    /// The starting poin of the gradient
    public var startGradientPoint: CGPoint = .init(x: 0.5, y: 0) {
        didSet {
            gradientLayer.startPoint = startGradientPoint
        }
    }

    /// The ending position of the gradient
    public var endGradientPoint: CGPoint = .init(x: 0.5, y: 1) {
        didSet {
            gradientLayer.endPoint = endGradientPoint
        }
    }

    /// Duration of the ring's fill animation
    public var duration: TimeInterval = 1.3

    /// Timing function of the ring's fill animation
    public var timingFunction: TimingFunction = .easeOutExpo

    /// The radius of the ring
    public var ringRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - ringWidth / 2
        if ringWidth < grooveWidth {
            radius -= (grooveWidth - ringWidth) / 2
        }
        return radius
    }

    /// The radius of the groove
    public var grooveRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - grooveWidth / 2
        if grooveWidth < ringWidth {
            radius -= (ringWidth - grooveWidth) / 2
        }
        return radius
    }

    /// The progress of the ring between 0 and 1. The ring will fill based on the value
    public private(set) var progress: CGFloat = 0

    /// Ring shape layer instance
    private let ringLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        return layer
    }()

    /// Groove shape layer instance
    private let grooveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }()

    /// Gradient layer instance
    private let gradientLayer = CAGradientLayer()

    // MARK: - Initializers

    /// Default initializer
    public init() {
        super.init(frame: .zero)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - UIView

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureRing()
        styleRingLayer()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleRingLayer()
    }

    // MARK: - Useful

    /// Set the progress value of the ring
    ///
    /// - Parameters:
    ///   - value: a progress value between 0 and 1
    ///   - animated: a flag for the fill ring's animation
    ///   - completion: a closure that called after an animation ends
    public func setProgress(_ value: Float, animated: Bool, completion: (() -> Void)? = nil) {
        layoutIfNeeded()
        let value = CGFloat(min(value, 1))
        let oldValue = ringLayer.presentation()?.strokeEnd ?? progress
        progress = value
        ringLayer.strokeEnd = progress
        guard animated else {
            layer.removeAllAnimations()
            ringLayer.removeAllAnimations()
            gradientLayer.removeAllAnimations()
            completion?()
            return
        }
        CATransaction.begin()
        let path = #keyPath(CAShapeLayer.strokeEnd)
        let fill = CABasicAnimation(keyPath: path)
        fill.fromValue = oldValue
        fill.toValue = value
        fill.duration = duration
        fill.timingFunction = timingFunction.function
        CATransaction.setCompletionBlock(completion)
        ringLayer.add(fill, forKey: "fill")
        CATransaction.commit()
    }

    // MARK: - Private

    private func setup() {
        preservesSuperviewLayoutMargins = true
        layer.addSublayer(grooveLayer)
        layer.addSublayer(gradientLayer)
        styleRingLayer()
    }

    private func styleRingLayer() {

        grooveLayer.strokeColor = grooveColor.cgColor
        grooveLayer.lineWidth = grooveWidth

        ringLayer.lineWidth = ringWidth
        ringLayer.strokeColor = UIColor.black.cgColor
        ringLayer.strokeEnd = min(progress, 1)

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        gradientLayer.shadowColor = startColor.cgColor
        gradientLayer.shadowOffset = .zero
    }

    private func configureRing() {

        let ringPath = ringPath()
        let groovePath = groovePath()

        grooveLayer.frame = bounds
        grooveLayer.path = groovePath

        ringLayer.frame = bounds
        ringLayer.path = ringPath

        gradientLayer.frame = bounds
        gradientLayer.mask = ringLayer
    }

    private func ringPath() -> CGPath {
        let center = CGPoint(
            x: bounds.origin.x + frame.width / 2,
            y: bounds.origin.y + frame.height / 2
        )
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: ringRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        return circlePath.cgPath
    }

    private func groovePath() -> CGPath {
        let center = CGPoint(
            x: bounds.origin.x + frame.width / 2,
            y: bounds.origin.y + frame.height / 2
        )
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: grooveRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        return circlePath.cgPath
    }
}
