// DetailsViewModel.swift
//
// Copyright © 2023 Vivek Amirapu. All rights reserved.

import Foundation
import UIKit

class DetailsViewModel {
    
    var networkService: NetworkServiceProtocol
    var dataCache: NSCache<NSString, AnyObject>
    var loadAvatar : ((_ image: UIImage) -> ()) = {image in }
    var addLabelsToView : ((_ labels: [UILabel]) -> ()) = {labels in }
    
    var github: GitUser
    
    init(networkService: NetworkService, dataCache: NSCache<NSString, AnyObject>, github: GitUser) {
        self.networkService = networkService
        self.dataCache = dataCache
        self.github = github
        //        self.callFuncToGetUserData()
    }
    
    func callFuncToGetUserData() {
        var detailLabels = [UILabel]()
        let dispatchGroup = DispatchGroup()
        
        /* Download Avatar and Cache it.*/
        if let savedImage = dataCache.object(forKey: NSString(string: "\(github.id)")) as? UIImage {
            DispatchQueue.main.async {
                self.loadAvatar(savedImage)
            }
        }
        else {
            AvatarDownloader().downloadAvatar(avatarID: "\(github.id)", size: .avatarSize) { result in
                switch result {
                case .success(let img):
                    self.dataCache.setObject(img, forKey: String(describing: self.github.id) as NSString)
                    DispatchQueue.main.async {
                        self.loadAvatar(img)
                    }
                case .failure:
                    break
                }
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: self.github.followers_url, resultType: [GitUser].self) { result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let followers):
                    let count = "\(followers.count)"
                    self.dataCache.setObject(NSString(string: count), forKey: String(describing: self.github.followers_url) as NSString)
                    detailLabels.append(self.makeLabel(text: "Followers: \(count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Followers: N/A"))
                }
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: self.github.following_url, resultType: [GitUser].self) { result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let followers):
                    let count = "\(followers.count)"
                    self.dataCache.setObject(NSString(string: count), forKey: String(describing: self.github.following_url) as NSString)
                    detailLabels.append(self.makeLabel(text: "Following: \(count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Following: N/A"))
                }
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: self.github.repos_url, resultType: [Repo].self) { result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let repositories):
                    let count = "\(repositories.count)"
                    self.dataCache.setObject(NSString(string: count), forKey: String(describing: self.github.repos_url) as NSString)
                    detailLabels.append(self.makeLabel(text: "Repositories count: \(count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Repositories count: N/A"))
                }
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: self.github.gists_url, resultType: [Gist].self) { result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let gists):
                    let count = "\(gists.count)"
                    self.dataCache.setObject(NSString(string: count), forKey: String(describing: self.github.gists_url) as NSString)
                    detailLabels.append(self.makeLabel(text: "Gists count: \(count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Gists count: N/A"))
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.addLabelsToView(detailLabels)
        }
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
