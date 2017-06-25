import Foundation
import Result
import BrightFutures

class Stream {
    func open(url: URL) -> Future<Data, NoError> {
        let promise = Promise<Data, NoError>()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            promise.success(data)
        }

        task.resume()
        return promise.future
    }

}
