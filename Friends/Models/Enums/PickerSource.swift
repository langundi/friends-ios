//
//  PickerSource.swift
//  Friends
//
//  Created by Ziqa on 31/08/26.
//

import Foundation
import UIKit

/// A delegate enum for UIImagePickerController source type to fix SwiftUI picker bug.
enum PickerSource: Identifiable {
    case camera
    case library
    
    var id: Self { self }
    
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera: .camera
        case .library: .photoLibrary
        }
    }
}
