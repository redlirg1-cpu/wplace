import UIKit
import AVFoundation

/// Wrapper around `AVCaptureTorchMode`.
public enum TorchMode {
    case on
    case off
    
    /// Returns the next torch mode.
    var next: TorchMode {
        switch self {
        case .on:
            return .off
        case .off:
            return .on
        }
    }
    
    /// Torch mode image.
    var image: UIImage {
        switch self {
        case .on:
            return imageNamed("TorchMode-On")
        case .off:
            return imageNamed("TorchMode-Off")
        }
    }
    
    /// Returns `AVCaptureTorchMode` value.
    var captureTorchMode: AVCaptureDevice.TorchMode {
        switch self {
        case .on:
            return .on
        case .off:
            return .off
        }
    }
}
