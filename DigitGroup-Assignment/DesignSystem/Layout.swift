//
//  Layout.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

// MARK: - Layout Constants
// Centralized spacing, padding, and sizing values

enum Layout {
    /// Standard spacing values
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    enum Padding {
        static let screen: CGFloat = 16
        static let card: CGFloat = 16
        static let section: CGFloat = 12
    }
    
    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let circle: CGFloat = 999
    }
    
    enum IconSize {
        static let xs: CGFloat = 16
        static let sm: CGFloat = 20
        static let md: CGFloat = 24
        static let lg: CGFloat = 32
        static let xl: CGFloat = 40
    }
    
    enum AvatarSize {
        static let sm: CGFloat = 40
        static let md: CGFloat = 60
        static let lg: CGFloat = 80
        static let xl: CGFloat = 120
    }
    
    enum Shadow {
        static func card() -> (color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
            (UIColor.black, 0.08, CGSize(width: 0, height: 2), 8)
        }
        
        static func elevated() -> (color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
            (UIColor.black, 0.12, CGSize(width: 0, height: 4), 12)
        }
    }
}
