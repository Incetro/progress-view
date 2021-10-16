//
//  ProgressBar.swift
//  ProgressView
//
//  Created by incetro on 10/16/21.
//

import UIKit

/// A fillable progress bar
open class ProgressBar: UIView {

    // MARK: - Properties

    /// Distance between groove and progress bar
    public var barEdgeInset: CGFloat = 0 {
        didSet {
            configureBar()
            styleBarLayer()
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
            barLayer.strokeColor = grooveColor.cgColor
        }
    }

    /// The starting poin of the gradient
    public var startGradientPoint: CGPoint = .init(x: 0, y: 0.5) {
        didSet {
            gradientLayer.startPoint = startGradientPoint
        }
    }

    /// The ending position of the gradient
    public var endGradientPoint: CGPoint = .init(x: 1, y: 0.5) {
        didSet {
            gradientLayer.endPoint = endGradientPoint
        }
    }

    /// Duration of the ring's fill animation
    public var duration: TimeInterval = 2.0

    /// Timing function of the ring's fill animation
    public var timingFunction: TimingFunction = .easeOutExpo

    /// The progress of the ring between 0 and 1. The ring will fill based on the value.
    public private(set) var progress: CGFloat = 0

    /// General shape layer
    private let mainLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }()

    /// Bar shape layer
    private let barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: - Initializers

    /// Default initalizer
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
        configureBar()
        styleBarLayer()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleBarLayer()
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
        let oldValue = mainLayer.presentation()?.strokeEnd ?? progress
        progress = value
        mainLayer.strokeEnd = progress
        guard animated else {
            layer.removeAllAnimations()
            mainLayer.removeAllAnimations()
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
        mainLayer.add(fill, forKey: "fill")
        CATransaction.commit()
    }


    private func setup() {
        preservesSuperviewLayoutMargins = true
        layer.addSublayer(barLayer)
        layer.addSublayer(gradientLayer)
        styleBarLayer()
        setProgress(Float(progress), animated: false)
    }

    private func styleBarLayer() {

        barLayer.strokeColor = grooveColor.cgColor
        barLayer.lineWidth = frame.height

        mainLayer.lineWidth = frame.height - (barEdgeInset * 2)
        mainLayer.strokeColor = startColor.cgColor
        mainLayer.strokeEnd = min(progress, 1)

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startGradientPoint
        gradientLayer.endPoint = endGradientPoint
    }

    private func configureBar() {

        let inset = frame.height / 2
        let barInset = barEdgeInset / 2

        let grooveLinePath = UIBezierPath()
        grooveLinePath.move(to: CGPoint(x: inset, y: bounds.midY))
        grooveLinePath.addLine(to: CGPoint(x: bounds.width - inset, y: bounds.midY))
        barLayer.path = grooveLinePath.cgPath

        let barLinePath = UIBezierPath()
        barLinePath.move(to: CGPoint(x: inset + barInset, y: bounds.midY))
        barLinePath.addLine(to: CGPoint(x: bounds.width - (inset + barInset), y: bounds.midY))
        mainLayer.path = barLinePath.cgPath

        [barLayer, mainLayer, gradientLayer].forEach { $0.frame = bounds }
        gradientLayer.mask = mainLayer
    }
}
