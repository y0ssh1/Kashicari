import Foundation

import Moya
import Alamofire
import SwiftyJSON

enum DjangoAPI {
    case getItems
    case postItem(name: String, description: String, imageUrl: String, price: Int, deadline: String, status: String, username: String)
    case sendImage(img: Data)
}

extension DjangoAPI: TargetType {

    var baseURL: URL {
        let baseURLString: String = "http://13.113.47.172"
        return URL(string: baseURLString)!
    }

    var path: String {
        switch self {

        case .getItems,
             .postItem:
            return "/exhibit/items/"
        case .sendImage:
            return "/split/"
        }
    }

    public var method: Moya.Method {
        switch self {

        case .postItem,
             .sendImage:
            return .post
        default:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .postItem(let name,
                       let description,
                       let imageUrl,
                       let price,
                       let deadline,
                       let status,
                       let username):
            return ["name": name, "description": description, "image_url": imageUrl,
                    "price": price, "deadline": deadline, "status": status, "username": username]
        default:
            return nil

        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        if case .sendImage(let img) = self {
            let multipartFormData = MultipartFormData(provider: .data(img.base64EncodedData()), name: "img")
            return .uploadMultipart([multipartFormData])
        }
        
        return .requestParameters(parameters: [:], encoding: parameterEncoding)
    }

    var headers: [String : String]? {
        
        return nil
    }

    var parameterEncoding: Moya.ParameterEncoding {

        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}


struct Network {

    static let queue = DispatchQueue(label: "com.lipscosme.LIPS.request", attributes: DispatchQueue.Attributes.concurrent)

    #if DEBUG
    static let plugins: [PluginType] = [
        NetworkLoggerPlugin(verbose: true)
    ]
    #else
    static let plugins: [PluginType] = []
    #endif

    static let provider = MoyaProvider<DjangoAPI>(
        endpointClosure: { (target: DjangoAPI) -> Endpoint<DjangoAPI> in

            let errorSampleResponseClosure = { () -> EndpointSampleResponse in

                return .networkResponse(200, "{\"mesasage\": \"mesasage\"}".data(using: String.Encoding.utf8)!)
            }

            let endpoint: Endpoint<DjangoAPI> = Endpoint<DjangoAPI>(
                url: target.baseURL.absoluteString + target.path,
                sampleResponseClosure: errorSampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: [:]
            )

            return endpoint
    },
        manager: manager,

        plugins: plugins
    )

    static let manager: Manager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10.0
        return Manager(configuration: configuration)
    }()

    static func request(
        target: DjangoAPI,
        success successCallback: @escaping (_ json: JSON) -> Void,
        error errorCallback: @escaping (_ statusCode: Int) -> Void,
        failure failureCallback: @escaping (Moya.MoyaError) -> Void
        ) -> Cancellable
    {

        return provider.request(target, callbackQueue: self.queue) { result in

            switch result {

            case let .success(response):

                do {
                    let _ = try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())

                    successCallback(json)
                }
                catch _ {

                    if response.statusCode == 200 {

                        successCallback(JSON.null)
                    }

                    DispatchQueue.main.async {

                        errorCallback(response.statusCode)
                    }
                }

            case let .failure(error):

                DispatchQueue.main.async {

                    failureCallback(error)
                }
            }
        }
    }

}
