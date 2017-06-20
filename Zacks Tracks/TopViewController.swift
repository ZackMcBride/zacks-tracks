import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GetPopularTracks().performRequest().onSuccess { tracks in
            print(tracks)
        }
    }
}

