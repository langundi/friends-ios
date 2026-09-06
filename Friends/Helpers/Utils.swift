//
//  Utils.swift
//  Friends
//
//  Created by Ziqa on 31/08/26.
//

import Foundation
import UIKit

func compressImageAndConvertToJPEG(image: UIImage) -> Data? {
    return image.jpegData(compressionQuality: 0.7)
}

nonisolated func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    let now = Date()
    
    if calendar.isDateInToday(date) {
        formatter.dateFormat = "HH.mm"
    } else if let daysAgo = calendar.dateComponents([.day], from: date, to: now).day, daysAgo < 7 {
        formatter.dateFormat = "EEEE"
    } else {
        formatter.dateFormat = "dd MMM yyyy"
    }
    
    return formatter.string(from: date)
}
