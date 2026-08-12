//
//  CameraManager.swift
//  Friends
//
//  Created by Ziqa on 11/08/26.
//

import UIKit
import AVFoundation

final class CameraManager: NSObject {
    
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.friends.cameraManager.sessionQueue")
    
    func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .restricted:
            print("Camera library access restricted.")
            return false
        case .denied:
            print("Camera access denied.")
            return false
        default:
            return false
        }
    }
    
    func configureSession() {
        session.beginConfiguration()
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice!) else {
            print("Failed to provide video input.")
            return
        }
        
        guard session.canAddInput(deviceInput) else {
            print("Failed to add device input to capture session.")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
        
        guard session.canAddOutput(photoOutput) else {
            print("Failed to add output to capture session.")
            return
        }
        
        session.sessionPreset = .photo
        session.addInput(deviceInput)
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }
    
    
}
