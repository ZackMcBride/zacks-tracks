import Foundation
import RealmSwift

class Track: Object {
    dynamic var uuid = ""
    dynamic var streamUrl = ""
    dynamic var rank = ""
    dynamic var externalUrl = ""
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var starredAt = ""

    override static func primaryKey() -> String? {
        return "uuid"
    }
}
