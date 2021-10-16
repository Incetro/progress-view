//
//  TimingFunction.swift
//  ProgressView
//
//  Created by incetro on 10/16/21.
//

import UIKit

// MARK: - TimingFunction

public enum TimingFunction: String, CaseIterable, Hashable {

    case `default`
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
    case easeOutExpo

    var function: CAMediaTimingFunction {
        switch self {
        case .`default`:
            return CAMediaTimingFunction(name: .default)
        case .linear:
            return CAMediaTimingFunction(name: .linear)
        case .easeIn:
            return CAMediaTimingFunction(name: .easeIn)
        case .easeOut:
            return CAMediaTimingFunction(name: .easeOut)
        case .easeInEaseOut:
            return CAMediaTimingFunction(name: .easeInEaseOut)
        case .easeOutExpo:
            return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        }
    }
}
