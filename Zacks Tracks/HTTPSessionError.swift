import Foundation

public enum HTTPSessionError<DeserializationError>: Error {

    case URLSessionError(NSError)
    case BadResponse
    case Redirection(Int)
    case ClientError(Int)
    case ServerError(Int)
    case DeserializationFailure(DeserializationError)

    case Other(Error)

    init(httpErrorStatusCode code: Int) {
        switch code {
        case 0..<300:
            fatalError()
        case 300..<400:
            self = .Redirection(code)
        case 400..<500:
            self = .ClientError(code)
        case 500..<600:
            self = .ServerError(code)
        default:
            self = .BadResponse
        }
    }
}
