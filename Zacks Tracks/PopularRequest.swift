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

            let track = Track()
            track.uuid = trackJson["uuid"]!.string!
            track.streamUrl = trackJson["stream_url"]!.string!
            track.rank = trackJson["rank"]!.string!
            track.externalUrl = trackJson["ext_url"]!.string!
            track.title = trackJson["title"]!.string!
            track.artist = trackJson["artist"]!.string!
            track.starredAt = trackJson["starred_at"]!.string!
            tracks.append(track)
        }

        return tracks
    }
}
