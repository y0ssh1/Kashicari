import UIKit
import AVFoundation
import Photos
import SnapKit

class cameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    private lazy var captureSession = AVCaptureSession()
    private lazy var capturePhotoOutput = AVCapturePhotoOutput()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer()
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    
    private lazy var cameraView: UIImageView = {
        let image = UIImageView()
        image.frame = view.frame
        return image
    }()
    
    private lazy var shutterButton: UIButton = {
        let image = UIImage(named: "shutterButton")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(takeIt), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("キャンセル", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor.translucentBlack
        button.layer.cornerRadius = 5
        button.titleLabel?.sizeToFit()
        button.sizeToFit()
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.backgroundColor = UIColor.translucentBlack
        indicator.layer.cornerRadius = 5
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @objc func takeIt() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        capturePhotoOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    @objc func cancelAction() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupView()
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupView() {
        view.addSubview(shutterButton)
        shutterButton.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
        })
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints({ (make) -> Void in
            make.centerY.equalTo(shutterButton)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(shutterButton.snp.left).offset(-20)
        })
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints({ (make) -> Void in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        })
        
        view.sendSubview(toBack: cameraView)
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .photo
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(input)
        captureSession.addOutput(capturePhotoOutput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // save Image in my folder
        guard let photoData = photo.fileDataRepresentation() else { return }
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: photoData, options: nil)
        })
        
        // send request
        UIApplication.shared.beginIgnoringInteractionEvents()
        indicator.startAnimating()
        Service.images.post(image: photoData, completion: { [weak self] images in
            let vc = ItemSelectViewController()
            vc.imageUrls = images
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let errorObj = error {
            print("Error in capture process: \(String(describing: errorObj))")
            return
        }
    }
}
