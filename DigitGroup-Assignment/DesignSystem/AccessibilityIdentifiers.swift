//
//  AccessibilityIdentifiers.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import Foundation

enum AccessibilityIdentifiers {
    
    enum PatientProfile {
        static let screen = "patient_profile_screen"
        static let avatar = "patient_profile_avatar"
        static let nameLabel = "patient_profile_name"
        static let infoLabel = "patient_profile_info"
        static let bloodTypeCard = "patient_profile_blood_type"
        static let heightCard = "patient_profile_height"
        static let weightCard = "patient_profile_weight"
        static let allergiesRow = "patient_profile_allergies"
        static let conditionsRow = "patient_profile_conditions"
        static let medicationsRow = "patient_profile_medications"
        static let insuranceRow = "patient_profile_insurance"
        static let emergencyRow = "patient_profile_emergency"
    }
    
    enum Appointments {
        static let screen = "appointments_screen"
        static let segmentControl = "appointments_segment_control"
        static let tableView = "appointments_table_view"
        static let addButton = "appointments_add_button"
        static let calendarButton = "appointments_calendar_button"
        static func appointmentCell(at index: Int) -> String {
            "appointment_cell_\(index)"
        }
    }
    
    enum AppointmentDetail {
        static let screen = "appointment_detail_screen"
        static let backButton = "appointment_detail_back"
        static let doctorName = "appointment_detail_doctor_name"
        static let specialty = "appointment_detail_specialty"
        static let dateCard = "appointment_detail_date"
        static let timeCard = "appointment_detail_time"
        static let locationCard = "appointment_detail_location"
        static let mapView = "appointment_detail_map"
        static let directionsButton = "appointment_detail_directions"
    }
    
    enum Vitals {
        static let screen = "vitals_screen"
        static let addButton = "vitals_add_button"
        static func vitalCard(type: String) -> String {
            "vital_card_\(type.lowercased().replacingOccurrences(of: " ", with: "_"))"
        }
    }
}
