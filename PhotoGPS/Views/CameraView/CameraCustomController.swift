//
//  CameraCustomController.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import AVFoundation
import CoreData

final class CameraCustomController: UIViewController {
    static let shared = CameraCustomController()
    
    private var captureSession = AVCaptureSession()
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    weak var captureDelegate: AVCapturePhotoCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configurePreviewLayer(with frame: CGRect) {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = frame
        
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
        
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        
        guard let delegate = captureDelegate else {
            print("delegate nil")
            return
        }
        photoOutput?.capturePhoto(with: settings, delegate: delegate)
    }
    
    // MARK: Private
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        for device in deviceDiscoverySession.devices {
            switch device.position {
            case AVCaptureDevice.Position.front:
                frontCamera = device
            case AVCaptureDevice.Position.back:
                backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    private func setupInputOutput() {
        do {
            guard let currentCamera = currentCamera else { return }
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            
            captureSession.addInput(captureDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])],
                completionHandler: nil
            )
            
            guard let photoOutput = photoOutput else { return }
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
}

final class CameraCustomRepresentable: UIViewControllerRepresentable {
    
    init(cameraFrame: CGRect, imageCompletion: @escaping ((Bool) -> Void)) {
        self.cameraFrame = cameraFrame
        self.imageCompletion = imageCompletion
    }
    
    var cameraFrame: CGRect
    var imageCompletion: ((Bool) -> Void)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CameraCustomController {
        CameraCustomController.shared.configurePreviewLayer(with: cameraFrame)
        CameraCustomController.shared.captureDelegate = context.coordinator
        return CameraCustomController.shared
    }
    
    func updateUIViewController(_ cameraViewController: CameraCustomController, context: Context) {}
    
    func takePhoto() {
        CameraCustomController.shared.takePhoto()
    }
    
    func startRunningCaptureSession() {
        CameraCustomController.shared.startRunningCaptureSession()
    }
    
    func stopRunningCaptureSession() {
        CameraCustomController.shared.stopRunningCaptureSession()
    }
}

extension CameraCustomRepresentable {
    final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        
        private var context = PersistenceController.shared.container.viewContext
        private let parent: CameraCustomRepresentable
        private let headingService = HeadingService.shared
        
        init(_ parent: CameraCustomRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            if let imageData = photo.fileDataRepresentation() {
                
                let gpsData = GPSData(context: self.context)
                gpsData.identifier = UUID()
                gpsData.saved = Date()
                gpsData.latitude = headingService.latitude
                gpsData.longitude = headingService.longitude
                gpsData.trueHeading = headingService.headingT
                gpsData.magneticHeading = headingService.headingM
                gpsData.elevation = headingService.elevation
                gpsData.accuracy = headingService.accuracy
                gpsData.image = imageData
                
                do {
                    try self.context.save()
                } catch {
                    let nsError = error as NSError
                    print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
                parent.imageCompletion(true)
            }
//            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

