
import UIKit
import Combine

class ListViewController: UICollectionViewController {
    
    private var listViewModel : ListViewModel!
    let networkService = NetworkService()
    let dataCache = NSCache<NSString, AnyObject>()
    private var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        listViewModel.callFuncToGetListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Function to observe various event call backs from the viewmodel
    private func setupBindings() {
        self.listViewModel =  ListViewModel(networkService: networkService, dataCache: dataCache)
        self.listViewModel.$avatarCellViewModels
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateDataSource()
            })
            .store(in: &bindings)
        
        
        self.listViewModel.validationResult
            .sink { completion in
                switch completion {
                case .failure:
                    // Error can be handled here (e.g. alert)
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] _ in
                self?.updateDataSource()
            }
            .store(in: &bindings)
    }
    
    func updateDataSource() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? AvatarCell, let cellVm = cell.cellViewModel, let githubUser = cellVm.githubUser else { return }
        guard let detailsViewController = segue.destination as? DetailsViewController else { return }
        detailsViewController.networkService = self.networkService
        detailsViewController.dataCache = dataCache
        detailsViewController.github = githubUser
    }
    
    // MARK: - Collectionview datasource methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listViewModel.avatarCellViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: AvatarCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AvatarCell else {
            return UICollectionViewCell()
        }
        let cellVm = listViewModel.getCellViewModel(at: indexPath)
        cell.indexPath = indexPath
        cellVm.indexPath = indexPath
        cell.cellViewModel = cellVm
        return cell
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    private var insets: UIEdgeInsets { UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0) }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 2 * insets.left, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}
