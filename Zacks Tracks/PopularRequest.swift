import Foundation
import SwiftyJSON

class PopularRequest: HTTPGETRequest, HTTPJsonRequest {
    enum RequestError: Error {
        case MissingToken
    }

    let parameters: [String: AnyObject] = [:]

    typealias Response = [Track]

    let path = "/popular"

    func deserialize(json: JSON, response: HTTPURLResponse) throws -> [Track] {
        let popularJson = json["popular"].array!

        var tracks = [Track]()
        for item in popularJson {

            let trackJson = item.dictionary!

            let track = Track(uuid: trackJson["uuid"]!.string!,
                              streamUrl: trackJson["stream_url"]!.string!,
                              rank: trackJson["rank"]!.string!,
                              externalUrl: trackJson["ext_url"]!.string!,
                              title: trackJson["title"]!.string!,
                              artist: trackJson["artist"]!.string!,
                              starredAt: trackJson["starred_at"]!.string!)
            tracks.append(track)
        }

        return tracks
    }
}
