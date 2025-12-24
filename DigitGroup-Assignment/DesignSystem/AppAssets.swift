//
//  AppAssets.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

enum AppAssets {
    
    enum Images {
        
        //For general images that are added in assets file
        static func image(named name: String) -> UIImage? {
            return UIImage(named: name)
        }
    }
    
    enum Icons {
        
        //For system icons with custom settings
        static func systemIcon(_ name: String, size: CGFloat? = nil, weight: UIImage.SymbolWeight = .regular) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: size ?? 20, weight: weight)
            return UIImage(systemName: name, withConfiguration: config)
        }
        
        static var calendar: UIImage? {
            return UIImage(named: "calendar")
        }
        
        static var calendarSystem: UIImage? {
            return UIImage(systemName: "calendar")
        }
        
        static var calendarSystemFill: UIImage? {
            return UIImage(systemName: "calendar.fill")
        }
        
        static var clock: UIImage? {
            return UIImage(named: "time")
        }
        
        static var hospital: UIImage? {
            return UIImage(named: "hospital")
        }
        
        static var rightArrow: UIImage? {
            return UIImage(systemName: "chevron.right")
        }
        
        static var leftArrow: UIImage? {
            return UIImage(systemName: "chevron.left")
        }
        
        static var arrowRight: UIImage? {
            return UIImage(systemName: "arrow.up.right")
        }
        
        static var video: UIImage? {
            return UIImage(systemName: "video.fill")
        }
        
        static var location: UIImage? {
            return UIImage(systemName: "mappin.circle.fill")
        }
        
        static var personCircle: UIImage? {
            return UIImage(systemName: "person.circle.fill")
        }
                    
        static var heartFill: UIImage? {
            return UIImage(systemName: "heart.fill")
        }
        
        static var heart: UIImage? {
            return UIImage(systemName: "heart")
        }
        
        static var respiratory: UIImage? {
            return UIImage(systemName: "wind")
        }
        
        static var plus: UIImage? {
            return UIImage(systemName: "plus")
        }
        
        static var personStraight: UIImage? {
            return UIImage(systemName: "person.fill")
        }
        
        static var person: UIImage? {
            return UIImage(systemName: "person")
        }
        
        static var drop: UIImage? {
            return UIImage(systemName: "drop.fill")
        }
        
        static var ruler: UIImage? {
            return UIImage(systemName: "ruler")
        }
        
        static var scalemass: UIImage? {
            return UIImage(systemName: "scalemass")
        }
        
        static var exclamationTriangle: UIImage? {
            return UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
        static var pills: UIImage? {
            return UIImage(systemName: "pills.fill")
        }
        
        static var cross: UIImage? {
            return UIImage(systemName: "cross.case.fill")
        }
        
        static var shield: UIImage? {
            return UIImage(systemName: "shield.fill")
        }
        
        static var phoneCircle: UIImage? {
            return UIImage(systemName: "phone.circle.fill")
        }
        
        static var info: UIImage? {
            return UIImage(systemName: "info.circle.fill")
        }
        
        static var thermometer: UIImage? {
            return UIImage(systemName: "thermometer.medium")
        }
        
        static var lungs: UIImage? {
            return UIImage(systemName: "lungs.fill")
        }
        
        static var stethoscope: UIImage? {
            return UIImage(systemName: "stethoscope")
        }
    }
}
