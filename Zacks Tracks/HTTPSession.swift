import Foundation
import BrightFutures
import SwiftyJSON

public struct HTTPSession {
    public static func performJsonRequest<DeserializationError: Error>(
        urlRequest: URLRequest,
        with session: URLSession)
        -> Future<(json: JSON, response: HTTPURLResponse), HTTPSessionError<DeserializationError>> {
            let promise = Promise<(json: JSON, response: HTTPURLResponse), HTTPSessionError<DeserializationError>>()

            let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
//                guard error == nil else {
//                    promise.failure(.URLSessionError(error! as NSError))
//                    return
//                }
//
//                guard let data = data, let response = response as? HTTPURLResponse else {
//                    promise.failure(.BadResponse)
//                    return
//                }
//
//                guard error == nil && 200..<300 ~= response.statusCode else {
//                    promise.failure(HTTPSessionError(httpErrorStatusCode: response.statusCode))
//                    return
//                }

                do {
                    let path = Bundle.main.path(forResource: "Sample", ofType: "JSON")!
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let json = JSON(data: data)

//                    let json = JSON(try JSONSerialization.jsonObject(with: data, options: []))
                    let tempResponse = HTTPURLResponse(url: URL(string: "test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                    promise.success((json, tempResponse))

                } catch {
                    promise.failure(.BadResponse)
                    return
                }
            }

            task.resume()

            return promise.future
    }

    public static func performDownloadRequest<DeserializationError: Error>(
        urlRequest: NSURLRequest,
        with session: URLSession)
        -> Future<(fileUrl: NSURL, response: HTTPURLResponse), HTTPSessionError<DeserializationError>> {
            let promise = Promise<(fileUrl: NSURL, response: HTTPURLResponse), HTTPSessionError<DeserializationError>>()

            let task = session.downloadTask(with: urlRequest as URLRequest) { localFileUrl, response, error in
                guard error == nil else {
                    promise.failure(.URLSessionError(error! as NSError))
                    return
                }

                guard let url = localFileUrl, let response = response as? HTTPURLResponse else {
                    promise.failure(.BadResponse)
                    return
                }

                guard error == nil && 200..<300 ~= response.statusCode else {
                    promise.failure(HTTPSessionError(httpErrorStatusCode: response.statusCode))
                    return
                }
                
                promise.success((url as NSURL, response))
            }
            
            task.resume()
            
            return promise.future
    }
}
