import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = QRScannerViewController

    @Binding var qrCode: String?

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let qrScannerViewController = QRScannerViewController()
        qrScannerViewController.delegate = context.coordinator
        return qrScannerViewController
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView

        init(_ parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                DispatchQueue.main.async {
                    self.parent.qrCode = stringValue
                }
            }
        }
    }
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var delegate: QRScannerView.Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self.delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

struct QRPage: View {
    @State private var qrCode: String?
    @State private var isShowingScanner = false

    var body: some View {
        Button(action: {
            isShowingScanner = true
        }) {
            Text("Start Scanning")
        }
        .sheet(isPresented: $isShowingScanner) {
            QRScannerView(qrCode: $qrCode)
        }
        .alert(isPresented: Binding.constant(qrCode != nil)) {
            Alert(title: Text("QR Code"), message: Text(qrCode ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

struct QRPage_Previews: PreviewProvider {
    static var previews: some View {
        QRPage()
    }
}
