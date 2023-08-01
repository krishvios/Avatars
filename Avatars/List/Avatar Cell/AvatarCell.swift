
import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    
    var sessionDataTask:URLSessionDataTask!
    var dataCache: NSCache<NSString, AnyObject>?
    var networkService: NetworkService?
    var indexPath: IndexPath?
    
    var cellViewModel: AvatarCellViewModel? {
        didSet {
            cellViewModel?.githubUser = cellViewModel?.githubUser
            loginLabel.text = cellViewModel?.githubUser?.login
            githubLabel.text = cellViewModel?.githubUser?.url
            cellViewModel?.loadAvatarImage = { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.startAnimating()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
    }
}
