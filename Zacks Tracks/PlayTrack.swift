import Foundation
import AVFoundation

class PlayTrack {
    private let track: Track
    private var player: AVAudioPlayer!

    init(track: Track) {
        self.track = track
    }

    func play() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let writePath = documents.appendingFormat("\(track.uuid).mp3")

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: writePath) {
            print("FILE AVAILABLE")
        } else {
            Stream().open(url: URL(string: track.streamUrl)!).onSuccess { data in
                try! data.write(to: URL(string: writePath)!)

                self.player = try! AVAudioPlayer(data: data)
                self.player.play()
            }
        }
    }
}
