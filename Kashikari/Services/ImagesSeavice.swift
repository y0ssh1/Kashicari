import Foundation

class ImagesService: NSObject {
    
    func post(image: Data, completion: (([String]) -> Void)?) {
        
        _ = Network.request(
            target: .sendImage(img: image),
            success: { json in
                if let imagesArray = json.dictionaryObject, let images = imagesArray["file_urls"] as? [String] {
                    completion?(images)
                }
        },
            error: { statusCode in
        },
            failure: { error in
        })
    }
}
