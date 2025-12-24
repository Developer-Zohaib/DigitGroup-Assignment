//
//  AppFonts.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

// MARK: - App Fonts
// Typography system with Dynamic Type support for accessibility

enum AppFonts {
    
    static func largeTitle(weight: UIFont.Weight = .bold) -> UIFont {
        let font = UIFont.systemFont(ofSize: 34, weight: weight)
        return UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
    }
    
    static func title1(weight: UIFont.Weight = .bold) -> UIFont {
        let font = UIFont.systemFont(ofSize: 28, weight: weight)
        return UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
    }
    
    static func title2(weight: UIFont.Weight = .bold) -> UIFont {
        let font = UIFont.systemFont(ofSize: 22, weight: weight)
        return UIFontMetrics(forTextStyle: .title2).scaledFont(for: font)
    }
    
    static func title3(weight: UIFont.Weight = .semibold) -> UIFont {
        let font = UIFont.systemFont(ofSize: 20, weight: weight)
        return UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
    }
    
    static func headline(weight: UIFont.Weight = .semibold) -> UIFont {
        let font = UIFont.systemFont(ofSize: 17, weight: weight)
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
    }
    
    static func body(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 17, weight: weight)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
    
    static func callout(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 16, weight: weight)
        return UIFontMetrics(forTextStyle: .callout).scaledFont(for: font)
    }
    
    static func subheadline(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 15, weight: weight)
        return UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: font)
    }
    
    static func footnote(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 13, weight: weight)
        return UIFontMetrics(forTextStyle: .footnote).scaledFont(for: font)
    }
    
    static func caption1(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 12, weight: weight)
        return UIFontMetrics(forTextStyle: .caption1).scaledFont(for: font)
    }
    
    static func caption2(weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: 11, weight: weight)
        return UIFontMetrics(forTextStyle: .caption2).scaledFont(for: font)
    }
}
