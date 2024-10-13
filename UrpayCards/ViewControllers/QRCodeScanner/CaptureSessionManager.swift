//
//  CaptureSessionManager.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import AVFoundation

class CaptureSessionManager: NSObject {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var session: AVCaptureSession? {
        return captureSession
    }
    
    func setupCaptureSession(delegate: AVCaptureMetadataOutputObjectsDelegate, on view: UIView) -> AVCaptureVideoPreviewLayer? {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession?.canAddInput(videoInput) == true {
                captureSession?.addInput(videoInput)
            }
        } catch {
            return nil
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession?.canAddOutput(metadataOutput) == true {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        return previewLayer
    }
    
    func startRunning() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopRunning() {
        captureSession?.stopRunning()
    }
    
    func teardown() {
        stopRunning()
        captureSession = nil
    }
}
