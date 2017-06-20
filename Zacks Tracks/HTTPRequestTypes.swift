import Foundation

public protocol HTTPGETRequest {
    var parameters: [String: AnyObject] { get }
}

public protocol HTTPPOSTRequest {
    var body: NSData? { get }
}
