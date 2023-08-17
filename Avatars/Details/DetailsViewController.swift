
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    @IBOutlet weak private var detailsStackView: UIStackView!
    
    var github: GitUser!
    var detailsViewModel: DetailsViewModel!
    var networkService: NetworkService?
    var dataCache: NSCache<NSString, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        usernameLabel.text = self.github.login
        githubLabel.text = "GitHub:\n\(self.github.html_url)"
        self.setup(linkLabel: self.githubLabel, text: self.github.html_url)
        
        self.detailsViewModel =  DetailsViewModel(networkService: self.networkService!, dataCache: self.dataCache!, github: self.github)
        
        self.detailsViewModel.loadAvatar = { (image: UIImage) -> () in
            self.imageView.image = image
        }
        
        self.detailsViewModel.addLabelsToView = { (labels: [UILabel]) -> () in
            DispatchQueue.main.async {
                labels.forEach { label in
                    DispatchQueue.main.async {
                        self.detailsStackView.addArrangedSubview(label)
                    }
                }
            }
        }
        detailsViewModel.callFuncToGetUserData()
    }
    
    func setup(linkLabel: UILabel, text: String) {
        linkLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openLink(sender:)))
        linkLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func openLink(sender: UITapGestureRecognizer) {
        if let openLink = URL(string: self.github.html_url) {
            if UIApplication.shared.canOpenURL(openLink) {
                UIApplication.shared.open(openLink, options: [:])
            }
        }
    }
    
}
