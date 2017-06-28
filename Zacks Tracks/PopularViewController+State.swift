import RealmSwift
import RxSwift

class PopularViewControllerState {

    let tracks = Variable<[Track]>([])

    func getTracks() {
        let realm = try! Realm()
        tracks.value = realm.objects(Track.self).map { $0 }
        FetchPopularTracks().performRequest().onSuccess { tracks in
            self.tracks.value = tracks
        }
    }
}
