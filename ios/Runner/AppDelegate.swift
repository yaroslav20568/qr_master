import Flutter
import UIKit
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let imageSaverChannel = FlutterMethodChannel(
      name: "qr_master/image_saver",
      binaryMessenger: controller.binaryMessenger
    )
    
    imageSaverChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "saveImageToGallery" {
        guard let args = call.arguments as? [String: Any],
              let imagePath = args["imagePath"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path is required", details: nil))
          return
        }
        
        self.saveImageToGallery(imagePath: imagePath) { success in
          result(success)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func saveImageToGallery(imagePath: String, completion: @escaping (Bool) -> Void) {
    guard let image = UIImage(contentsOfFile: imagePath) else {
      completion(false)
      return
    }
    
    PHPhotoLibrary.requestAuthorization { status in
      guard status == .authorized || status == .limited else {
        completion(false)
        return
      }
      
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: image)
      }) { success, error in
        DispatchQueue.main.async {
          if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            completion(false)
          } else {
            completion(success)
          }
        }
      }
    }
  }
}
