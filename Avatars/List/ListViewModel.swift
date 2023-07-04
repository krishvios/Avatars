// ListViewModel.swift
//
// Copyright © 2023 Stepstone. All rights reserved.

import Foundation

class ListViewModel: NSObject {
    
    let networkService = NetworkService()
    var dataCache = NSCache<NSString, AnyObject>()
    var bindListViewModelToController : (() -> ()) = {}
    var githubUsers = [GitUser]() {
        didSet {
            self.bindListViewModelToController()
        }
    }
    
    override init() {
        super.init()
        callFuncToGetListData()
    }
    
    func callFuncToGetListData() {
        networkService.get(url: .githubUsersEndpoint, resultType: [GitUser].self) { result in
            switch result {
            case .failure:
                self.githubUsers = []
            case .success(let users):
                self.githubUsers = users
            }
        }
    }
    
}
