//
//  QRCodeScannerVC.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 09/10/2024.
//

import UIKit
import AVFoundation

class QRCodeScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Properties
    
    private var captureSessionManager: CaptureSessionManager!
    private var uiManager: QRUIManager!
    private let completionHandler: ((_ qr: String) -> Void)?
    
    // MARK: - Initialization
    
    init(completionHandler: ((_ qr: String) -> Void)?) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager = CaptureSessionManager()
        uiManager = QRUIManager()
        checkCameraAuthorization()
        uiManager.setupCancelButton(in: view, target: self, action: #selector(cancelButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSessionManager.session?.isRunning == false {
            captureSessionManager.startRunning()
            uiManager.resetQRCodeFrame()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSessionManager.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSessionManager.session?.startRunning()
        }
    }
    
    // MARK: - Camera Setup Methods
    
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCaptureSession()
                    } else {
                        AlertHelper.showAlert(on: self!, title: "Camera Access Denied", message: "Please enable camera access in Settings.")
                    }
                }
            }
        case .denied, .restricted:
            AlertHelper.showAlert(on: self, title: "Camera Access Denied", message: "Please enable camera access in Settings.")
        @unknown default:
            break
        }
    }
    
    private func setupCaptureSession() {
        if captureSessionManager.setupCaptureSession(delegate: self, on: view) != nil {
            _ = self.uiManager.setupQRCodeFrame(in: view)
            _ = self.uiManager.setupQRCodeLabel(in: view)
        } else {
            AlertHelper.showAlert(on: self, title: "Error", message: "Unable to initialize camera")
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metadataObject.type == .qr,
           let stringValue = metadataObject.stringValue {
            captureSessionManager.stopRunning()
            completionHandler?(stringValue)
            //dismiss(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        captureSessionManager.stopRunning()
        dismiss(animated: true, completion: nil)
    }
}
