import Foundation
import SwiftyJSON

public protocol HTTPRequest {
    associatedtype RequestError: Error
    var path: String { get }
}

public protocol HTTPJsonRequest: HTTPRequest {
    associatedtype Response

    func deserialize(json: JSON, response: HTTPURLResponse) throws -> Response
}

public protocol HTTPDownloadRequest: HTTPRequest {
    associatedtype Response

    func deserialize(url: NSURL, response: HTTPURLResponse) throws -> Response
}
