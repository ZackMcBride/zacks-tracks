import Foundation
import SwiftyJSON

class PopularRequest: HTTPGETRequest, HTTPJsonRequest {
    enum RequestError: Error {
        case MissingToken
    }

    let parameters: [String: AnyObject] = [:]

    typealias Response = [Track]

    let path = "/tracks"

    func deserialize(json: JSON, response: HTTPURLResponse) throws -> [Track] {
        let popularJson = json["popular"].array!

        var tracks = [Track]()
        for item in popularJson {

            let trackJson = item.dictionary!

            let track = Track()
            track.uuid = trackJson["uuid"]!.string!
            track.streamUrl = trackJson["streamUrl"]!.string!
            // TODO 
            track.rank = String(trackJson["rank"]!.int!)
            track.externalUrl = trackJson["externalUrl"]!.string!
            track.title = trackJson["title"]!.string!
            // TODO Strongly type artist
            track.artist = trackJson["artist"]!["name"].string!
            track.starredAt = trackJson["starredAt"]!.string!
            // TODO Deal with player
            tracks.append(track)
        }

        return tracks
    }
}
