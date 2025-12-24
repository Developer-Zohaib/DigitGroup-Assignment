//
//  AppColors.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

enum AppColors {
    static let primary = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    static let secondary = UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0)
    static let accent = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
    
    static let background = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
            : UIColor(red: 245/255, green: 247/255, blue: 250/255, alpha: 1.0)
    }
    
    static let cardBackground = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
            : UIColor.white
    }
    
    static let textPrimary = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }
    
    static let textSecondary = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
            : UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
    }
    
    static let textTertiary = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
            : UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0)
    }
    
    static let separator = UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
            : UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
    }
    
    static let success = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    static let warning = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
    static let error = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1.0)
    static let info = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    
    static let bloodType = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    static let height = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    static let weight = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    
    static let heartRate = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1.0)
    static let bloodPressure = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    static let temperature = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
    static let oxygen = UIColor(red: 100/255, green: 181/255, blue: 246/255, alpha: 1.0)
    static let respiratory = UIColor(red: 77/255, green: 208/255, blue: 225/255, alpha: 1.0)
    
    static let statusConfirmed = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
    static let statusPending = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
    static let statusCancelled = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0)
    
    static let onlineStatus = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
}
