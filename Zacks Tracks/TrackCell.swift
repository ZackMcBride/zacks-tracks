import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

}
