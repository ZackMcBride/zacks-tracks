import AVFoundation
import UIKit
import RxSwift

class PopularViewController: UIViewController {

    private var state: PopularViewControllerState!
    private let disposeBag = DisposeBag()
    private var player: AVAudioPlayer!

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

    fileprivate func startStreaming(track: Track) {
        Stream().open(url: URL(string: track.streamUrl)!).onSuccess { data in

            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let writePath = documents.appendingFormat("\(track.uuid).mp3")

            try! data.write(to: URL(string: writePath)!)

            self.player = try! AVAudioPlayer(data: data)
            self.player.play()
        }
    }
}

extension PopularViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        startStreaming(track: track)
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


