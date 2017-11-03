import Foundation
import ObjectMapper

class Item: Mappable {
    var name: String = ""
    var description: String = ""
    var price: Int = 0
    var imgUrl: String = ""
    
    init(image: String){
        imgUrl = image
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        description <- map["description"]
        price <- map["price"]
        imgUrl <- map["image_url"]
    }
}
