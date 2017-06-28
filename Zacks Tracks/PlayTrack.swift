import Foundation
import AVFoundation

class PlayTrack {
    private var player: AVAudioPlayer!

    func play(track: Track) {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let writePath = documents.appendingFormat("/\(track.uuid).mp3")

        let fileManager = FileManager.default
        // TODO Actually do some error handling
        if fileManager.fileExists(atPath: writePath) {
            let data = try! Data(contentsOf: URL(fileURLWithPath: writePath))

            self.player = try! AVAudioPlayer(data: data)
            self.player.play()
        } else {
            Stream().open(url: URL(string: track.streamUrl)!).onSuccess { data in
                let url = URL(fileURLWithPath: writePath)
                try! data.write(to: url)

                self.player = try! AVAudioPlayer(data: data)
                self.player.play()
            }
        }
    }
}
