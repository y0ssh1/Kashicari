import UIKit

import SwiftyJSON
import ObjectMapper

class ItemsService: NSObject {

    func index(completion: (([Item]) -> Void)?) {
        
        _ = Network.request(
            target: .getItems,
            success: { json in
                let items: [Item] = Mapper<Item>().mapArray(JSONArray: json.arrayValue.map({ $0.dictionaryObject! }))
                completion?(items)
        },
            error: { statusCode in
        },
            failure: { error in
        })
    }
    
    func post(name: String = "", description: String = "", imageUrl: String = "https://s3-ap-northeast-1.amazonaws.com/kashicari/a48a16bd-02cc-41e5-ac22-e72809137c5f.png", price: Int = 0, deadline: String = "2017-9-4", status: String = "unavailable", username: String = "よしの かつき",
              completion: (() -> Void)?) {
            _ = Network.request(
                target: .postItem(name: name, description: description, imageUrl: imageUrl, price: price, deadline: deadline, status: status, username: username),
                success: {json in
                    if let item = Mapper<Item>().map(JSON: json.dictionaryObject! ){
                        print(item)
                    }
                    
                    completion?()
            }, error: {statusCode in
                
            }, failure: {error in
                
            })
        }
}
