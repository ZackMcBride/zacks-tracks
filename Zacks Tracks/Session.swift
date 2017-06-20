import BrightFutures
import SwiftyJSON

public class Session: NSObject {

    // MARK: Private properties

    typealias StoreDetails = (storeUuid: String, timezone: String)

    private let maxAuthenticationRequestAttempts = 3
    private let baseUrl = NSURL(string: "https://api.zackstracks.com")!
    private let session: JsonAPISession

    // MARK: Public methods

    init(session: JsonAPISession) {
        self.session = session
    }

    public func perform<Request: HTTPJsonRequest>(request: Request)
        -> Future<Request.Response, HTTPSessionError<Request.RequestError>> where Request: HTTPGETRequest {
            let url = baseUrl.appendingPathComponent(request.path)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"

            URLParameterEncoder.encode(urlRequest: urlRequest, parameters: request.parameters)
            return fetch(jsonUrlRequest: JsonUrlRequest(urlRequest: urlRequest, request: request))
    }

    public func fetch<Request: HTTPJsonRequest>(jsonUrlRequest: JsonUrlRequest<Request>) -> Future<Request.Response, HTTPSessionError<Request.RequestError>> where Request: HTTPGETRequest {
        let urlRequest = urlRequestWithServiceHeaders(request: jsonUrlRequest.urlRequest)
        let fetchRequest = JsonUrlRequest(urlRequest: urlRequest, request: jsonUrlRequest.request)

        return session.fetch(jsonUrlRequest: fetchRequest)
    }

    // MARK: Private methods

    private func urlRequestWithServiceHeaders(request: URLRequest) -> URLRequest {
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
            ]

        var urlRequest = request

        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
