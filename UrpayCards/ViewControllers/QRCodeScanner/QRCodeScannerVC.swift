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
    
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var qrCodeFrameView: UIView!
    private var qrCodeLabel: UILabel!
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
        checkCameraAuthorization()
        setupCancelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession.startRunning()
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeLabel.text = "Scanning for QR Code..."
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = view.bounds
        if let connection = videoPreviewLayer?.connection, connection.isVideoOrientationSupported {
            switch UIDevice.current.orientation {
            case .portrait:
                connection.videoOrientation = .portrait
            case .landscapeRight:
                connection.videoOrientation = .landscapeLeft
            case .landscapeLeft:
                connection.videoOrientation = .landscapeRight
            case .portraitUpsideDown:
                connection.videoOrientation = .portraitUpsideDown
            default:
                connection.videoOrientation = .portrait
            }
        }
    }
    
    // MARK: - Setup Methods
    
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
                        self?.showAlert(title: "Camera Access Denied", message: "Please enable camera access in Settings.")
                    }
                }
            }
        case .denied, .restricted:
            showAlert(title: "Camera Access Denied", message: "Please enable camera access in Settings.")
        @unknown default:
            break
        }
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(title: "Camera Not Found", message: "Your device does not support scanning.")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                showAlert(title: "Input Error", message: "Could not add video input.")
                return
            }
        } catch {
            showAlert(title: "Input Error", message: "Could not create video input.")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(title: "Output Error", message: "Could not add metadata output.")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
        setupUI()
    }
    
    private func setupUI() {
        // QR Code Frame
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        // QR Code Label
        qrCodeLabel = UILabel()
        qrCodeLabel.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 50)
        qrCodeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        qrCodeLabel.textColor = UIColor.white
        qrCodeLabel.textAlignment = .center
        qrCodeLabel.text = "Scanning for QR Code..."
        view.addSubview(qrCodeLabel)
        view.bringSubviewToFront(qrCodeLabel)
    }
    
    private func setupCancelButton() {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        cancelButton.layer.cornerRadius = 5
        cancelButton.frame = CGRect(x: 20, y: 40, width: 80, height: 40)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        view.bringSubviewToFront(cancelButton)
    }
    
    @objc private func cancelButtonTapped() {
        captureSession?.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           readableObject.type == .qr,
           let stringValue = readableObject.stringValue {
            qrCodeLabel.text = "QR Code: \(stringValue)"
            captureSession.stopRunning()
            completionHandler?(stringValue)
            self.dismiss(animated: true, completion: nil)
        } else {
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeLabel.text = "Scanning for QR Code..."
        }
        
        // Highlight QR code
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: readableObject) {
            qrCodeFrameView?.frame = barCodeObject.bounds
        }
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alertController, animated: true)
    }
    
    // MARK: - Deinitialization
    
    deinit {
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
        captureSession = nil
    }
}
