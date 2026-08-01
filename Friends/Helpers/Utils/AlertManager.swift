//
//  AlertManager.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import SwiftUI

/// Manages custom alert using SwiftUI's `.alert` modifier.
///
/// This class can be used globaly using a shared singleton. Alert can be used for errors or actions that needed confirmation.
/// A general error alert is available for unknown errors. Custom actions can be passed using the `action` properties.
@Observable
final class AlertManager {
    static let shared = AlertManager()
    
    private init() { }
    
    var isShowingAlert = false
    var alertTitle = "Error"
    var alertMessage = "Something went wrong, please try again later."
    var primaryAction: AlertAction?
    var secondaryAction: AlertAction?
    
    struct AlertAction {
        let title: String
        var action: (() -> Void)?
    }
}

extension AlertManager {
    
    /// Show alert with custom properties.
    func showAlert(
        title: String? = nil,
        message: String,
        action: AlertAction? = nil
    ) {
        alertTitle = title ?? "Error"
        alertMessage = message
        primaryAction = action
        isShowingAlert = true
    }
    
    /// Show alert with custom properties and two actions.
    func showAlert(
        title: String? = nil,
        message: String,
        primaryAction: AlertAction? = nil,
        secondaryAction: AlertAction? = nil
    ) {
        alertTitle = title ?? "Error"
        alertMessage = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        isShowingAlert = true
    }
    
    /// Show alert for an error.
    func showAlert(for error: Error) {
        alertTitle = "An error occured"
        alertMessage = error.localizedDescription
        primaryAction = nil
        isShowingAlert = true
    }
    
    /// Show a general error alert.
    func showGeneralAlert() {
        showAlert(message: "An unexpected issue occurred. Please try again later.")
    }
    
    /// Clear AlertManager properties.
    func clearAlert() {
        alertTitle = "Error"
        alertMessage = "Something went wrong, please try again later."
        primaryAction = nil
        isShowingAlert = false
    }
    
}
