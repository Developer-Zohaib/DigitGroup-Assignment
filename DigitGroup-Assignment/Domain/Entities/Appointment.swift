//
//  Appointment.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation

/// Appointment entity with scheduling and location details
struct AppointmentEntity: Equatable, Identifiable {
    let id: String
    let doctorName: String
    let specialty: String
    let scheduledDate: Date
    let duration: TimeInterval
    let type: AppointmentType
    let location: AppointmentLocation
    let status: AppointmentStatus
    
    // Computed date checks for filtering
    var isUpcoming: Bool { scheduledDate > Date() }
    var isPast: Bool { scheduledDate <= Date() }
    var isToday: Bool { Calendar.current.isDateInToday(scheduledDate) }
    var isThisWeek: Bool { Calendar.current.isDate(scheduledDate, equalTo: Date(), toGranularity: .weekOfYear) }
}

/// Video, in-person, or phone appointment
enum AppointmentType: String, Equatable {
    case video = "Video Consultation"
    case inPerson = "In-Person"
    case phone = "Phone Call"
    
    var isVideo: Bool { self == .video }
}

/// Location with optional coordinates for map display
struct AppointmentLocation: Equatable {
    let name: String
    let address: String?
    let coordinates: Coordinates?
    
    var displayText: String { address.map { "\(name), \($0)" } ?? name }
}

struct Coordinates: Equatable {
    let latitude: Double
    let longitude: Double
}

/// Appointment lifecycle status
enum AppointmentStatus: String, Equatable {
    case scheduled, confirmed, inProgress, completed, cancelled, noShow
}
