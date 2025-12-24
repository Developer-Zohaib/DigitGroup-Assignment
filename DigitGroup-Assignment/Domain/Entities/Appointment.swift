//
//  Appointment.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation

struct AppointmentEntity: Equatable, Identifiable {
    let id: String
    let doctorName: String
    let specialty: String
    let scheduledDate: Date
    let duration: TimeInterval
    let type: AppointmentType
    let location: AppointmentLocation
    let status: AppointmentStatus
    
    var isUpcoming: Bool {
        scheduledDate > Date()
    }
    
    var isPast: Bool {
        scheduledDate <= Date()
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(scheduledDate)
    }
    
    var isThisWeek: Bool {
        Calendar.current.isDate(scheduledDate, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

enum AppointmentType: String, Equatable {
    case video = "Video Consultation"
    case inPerson = "In-Person"
    case phone = "Phone Call"
    
    var isVideo: Bool {
        self == .video
    }
}

struct AppointmentLocation: Equatable {
    let name: String
    let address: String?
    let coordinates: Coordinates?
    
    var displayText: String {
        if let address = address {
            return "\(name), \(address)"
        }
        return name
    }
}

struct Coordinates: Equatable {
    let latitude: Double
    let longitude: Double
}

enum AppointmentStatus: String, Equatable {
    case scheduled
    case confirmed
    case inProgress
    case completed
    case cancelled
    case noShow
}
