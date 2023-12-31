// ListViewModel.swift
//
// Copyright © 2023 Vivek Amirapu. All rights reserved.

import Combine
import Foundation

class ListViewModel {
    
    private var networkService: NetworkServiceProtocol
    var dataCache: NSCache<NSString, AnyObject>
    private let reloadUsersListSubject = PassthroughSubject<Result<Void, NetworkError>, Never>()
    private var subscribers: [AnyCancellable] = []
    let validationResult = PassthroughSubject<Void, Error>()

    @Published private(set) var avatarCellViewModels: [AvatarCellViewModel] = []
    @Published var isSubmitAllowed: Bool = false

    // MARK: Output
    var numberOfRows: Int {
        avatarCellViewModels.count
    }
    
    var reloadUsersList: AnyPublisher<Result<Void, NetworkError>, Never> {
        reloadUsersListSubject.eraseToAnyPublisher()
    }
    
    init(networkService: NetworkService, dataCache: NSCache<NSString, AnyObject>) {
        self.networkService = networkService
        self.dataCache = dataCache
    }

    func callFuncToGetListData() {
        self.networkService.get(url: Constants.githubUsersEndpoint) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let users = try JSONDecoder().decode([GitUser].self, from: data)
                    self?.fetchData(githubUsers: users)
                } catch {
                    print(NetworkError.decode)
                }
                self?.validationResult.send(())
            case let .failure(error):
                self?.validationResult.send(completion: .failure(error))
            }
        }
    }
    
    func fetchData(githubUsers: [GitUser]) {
        var vms = [AvatarCellViewModel]()
        for user in githubUsers {
            vms.append(createCellModel(user: user))
        }
        avatarCellViewModels = vms
    }
    
    func createCellModel(user: GitUser) -> AvatarCellViewModel {
        let model = AvatarCellViewModel()
        model.dataCache = self.dataCache
        model.networkService = self.networkService
        model.githubUser = user
        return model
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> AvatarCellViewModel {
        return avatarCellViewModels[indexPath.row]
    }
    
}
