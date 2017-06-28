import BrightFutures
import Foundation
import SwiftyJSON

public class JsonAPISession: NSObject {

    public struct ClientInfo {
        let clientUuid: String
        let appVersion: String
        let bundleName: String
        let deviceModel: String
        let deviceSystemVersion: String

        public init(
            clientUuid: String,
            appVersion: String,
            bundleName: String,
            deviceModel: String,
            deviceSystemVersion: String) {
            self.clientUuid = clientUuid
            self.appVersion = appVersion
            self.bundleName = bundleName
            self.deviceModel = deviceModel
            self.deviceSystemVersion = deviceSystemVersion
        }
    }

    // MARK: Private properties

    private let maxAuthenticationRequestAttempts = 3
    private let session: URLSession
    private let clientUuid: String
    private let userAgent: String


    // MARK: Lifecycle

    public init(
        session: URLSession,
        clientInfo: ClientInfo) {
        self.session = session
        self.userAgent = JsonAPISession.userAgent(clientInfo: clientInfo)
        self.clientUuid = clientInfo.clientUuid
    }

    public func post<Request: HTTPJsonRequest>(jsonUrlRequest: JsonUrlRequest<Request>) -> Future<Request.Response, HTTPSessionError<Request.RequestError>> where Request: HTTPPOSTRequest {
        return  performJsonRequest(jsonUrlRequest: jsonUrlRequest)
            .flatMap { (json, httpResponse) -> Future<Request.Response, HTTPSessionError<Request.RequestError>> in
                do {
                    let deserialized = try jsonUrlRequest.request.deserialize(json: json, response: httpResponse)
                    return Future(value: deserialized)
                } catch let e as Request.RequestError {
                    return Future(error: .DeserializationFailure(e))
                } catch {
                    return Future(error: .Other(error))
                }
        }
    }

    public func fetch<Request: HTTPJsonRequest>(
        jsonUrlRequest: JsonUrlRequest<Request>) -> Future<Request.Response, HTTPSessionError<Request.RequestError>> where Request: HTTPGETRequest {
        return performJsonRequest(jsonUrlRequest: jsonUrlRequest)
            .flatMap { (json, httpResponse) -> Future<Request.Response, HTTPSessionError<Request.RequestError>> in
                do {
                    let deserialized = try jsonUrlRequest.request.deserialize(json: json, response: httpResponse)
                    return Future(value: deserialized)
                } catch let e as Request.RequestError {
                    return Future(error: .DeserializationFailure(e))
                } catch {
                    return Future(error: .Other(error))
                }
        }
    }

    // MARK: Private methods

    private func performJsonRequest<Request: HTTPJsonRequest>(jsonUrlRequest: JsonUrlRequest<Request>) -> Future<(json: JSON, response: HTTPURLResponse), HTTPSessionError<Request.RequestError>> {
        var urlRequest = requestWithDefaultHeaders(request: jsonUrlRequest.urlRequest)

        var reauthenticationAttempts = 0
        var recoverWithAuthRetries: ((HTTPSessionError<Request.RequestError>) -> Future<(json: JSON, response: HTTPURLResponse), HTTPSessionError<Request.RequestError>>)!
        recoverWithAuthRetries = { error in
            guard reauthenticationAttempts < self.maxAuthenticationRequestAttempts else { return Future(error: error) }
            reauthenticationAttempts += 1

            switch error {
//            case .ClientError(let code) where code == unauthorized: break

                // TODO AUTH
                //                return self.authTokenManager.renewAuthToken()
//                    .mapError { error -> HTTPSessionError<Request.RequestError> in
//                        return .ClientError(unauthorized)
//                    }
//                    .flatMap { token -> Future<(json: JSON, response: HTTPURLResponse), HTTPSessionError<Request.RequestError>> in
//                        self.setAuthorizationHeader(on: urlRequest, to: token)
//                        return HTTPSession.performJsonRequest(urlRequest: urlRequest, with: self.session)
//                    }
//                    .recoverWith(task: recoverWithAuthRetries)
            default:
                return Future(error: error)
            }
        }

        return HTTPSession
            .performJsonRequest(urlRequest: urlRequest, with: self.session)
            .recoverWith(task: recoverWithAuthRetries)
    }

    private func requestWithDefaultHeaders(request: URLRequest) -> URLRequest {
        let headers = [
            "User-Agent": userAgent,
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]

        var urlRequest = request

        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }


    private static func userAgent(clientInfo: ClientInfo) -> String {
        return "\(clientInfo.bundleName)/\(clientInfo.appVersion) (\(clientInfo.deviceModel); iOS \(clientInfo.deviceSystemVersion);))"
    }
}

private let unauthorized = 401
