import AVFoundation
import UIKit
import RxSwift

class PopularViewController: UIViewController {

    private var state: PopularViewControllerState!
    private let disposeBag = DisposeBag()

    fileprivate var tracks: [Track] = [Track]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        state = PopularViewControllerState()
        state.getTracks()
        watchChanges(to: state)
    }


    @IBAction func refreshPressed(_ sender: Any) {
        state.getTracks()
    }

    private func watchChanges(to state: PopularViewControllerState) {
        state.tracks.asObservable().subscribe { [weak self] event in
            switch event {
            case .next(let tracks):
                self?.tracks = tracks
                self?.tableView.reloadData()
            default:break
            }
        }.addDisposableTo(disposeBag)
    }
}

extension PopularViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var player = AVPlayer()
        let playerItem = AVPlayerItem(url: URL(string: "http://url.com/")!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0;
        player.play()
    }

}

extension PopularViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.title = "\(track.artist) - \(track.title)"
        return cell
    }
}

