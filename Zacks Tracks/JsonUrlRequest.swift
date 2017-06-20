import Foundation

public struct JsonUrlRequest<Request: HTTPJsonRequest> {
    let urlRequest: URLRequest
    let request: Request

    init(url: String, request: Request) {
        self.urlRequest = URLRequest(url: NSURL(string: url)! as URL)
        self.request = request
    }

    init(urlRequest: URLRequest, request: Request) {
        self.urlRequest = urlRequest
        self.request = request
    }
}
