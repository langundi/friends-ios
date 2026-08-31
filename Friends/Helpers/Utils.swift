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
