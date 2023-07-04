
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    @IBOutlet weak private var detailsStackView: UIStackView!
    
    var github: GitUser!
    var detailsViewModel: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        usernameLabel.text = self.github.login
        githubLabel.text = "GitHub:\n\(self.github.html_url)"
        
        self.detailsViewModel =  DetailsViewModel(github: github)
        
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
    }
}
