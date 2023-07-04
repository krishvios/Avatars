
import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    var indexPath: IndexPath?
    var sessionDataTask:URLSessionDataTask!
    var dataCache = NSCache<NSString, AnyObject>()
    var networkService: NetworkService?

    var login: String? {
        get {
            loginLabel.text
        }
        set {
            loginLabel.text = newValue
        }
    }

    var github: String? {
        get {
            githubLabel.text
        }
        set {
            githubLabel.text = "GitHub: \(newValue ?? "N/A")"
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var githubUser: GitUser? {
        didSet {
            login = githubUser?.login
            github = githubUser?.html_url

            activityIndicator.startAnimating()
            if let indexPath = self.indexPath {
                self.imageView.tag = indexPath.row
            }
            self.imageView.image = nil
            
            /* Download Avatar and Cache it.*/
            if let Id = githubUser?.id {
                if let savedImage = dataCache.object(forKey: NSString(string: "\(Id)")) {
                    DispatchQueue.main.async {
                        self.imageView.image = savedImage as? UIImage
                    }
                }
                else {
                    AvatarDownloader().downloadAvatar(avatarID: "\(Id)", size: 4) { result in
                        switch result {
                        case .success(let img):
                            self.dataCache.setObject(img, forKey: String(describing: self.githubUser?.id) as NSString)
                            DispatchQueue.main.async {
                                self.imageView.image = img
                            }
                        case .failure:
                            break
                        }
                    }
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

        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
    }
}
