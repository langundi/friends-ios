//
//  NotificationViewModel.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import Foundation
import OSLog

@Observable
final class NotificationViewModel {
    
    var isLoading: Bool = false
    var notifications: [NotificationResponse] = []
    
    private let notificationService: NotificationService
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }
    
    func getAllNotification() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            notifications = try await notificationService.getAllNotification() ?? []
        } catch let networkError as NetworkError {
            switch networkError {
            case .noDataRecieved:
                Logger.network.warning("Notifications: \(networkError.message)")
            default:
                AlertManager.shared.showAlert(title: "An error occured", message: networkError.message)
                Logger.network.error("Error fetching notifications: \(networkError.message)")
            }
        } catch {
            if error.isCancellation { return }
            AlertManager.shared.showAlert(title: "An error occured", message: error.localizedDescription)
            Logger.network.error("Error fetching notifications: \(error)")
        }
    }
    
}
