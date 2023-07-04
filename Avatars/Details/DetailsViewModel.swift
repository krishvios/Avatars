// DetailsViewModel.swift
//
// Copyright © 2023 Stepstone. All rights reserved.

import Foundation
import UIKit

class DetailsViewModel: NSObject {
    
    let networkService = NetworkService()
    var dataCache = NSCache<NSString, AnyObject>()
    var loadAvatar : ((_ image: UIImage) -> ()) = {image in }
    var addLabelsToView : ((_ labels: [UILabel]) -> ()) = {labels in }

    var github: GitUser

    override convenience init() {
        self.init()
    }
    
    init(github: GitUser) {
        self.github = github
        super.init()
        self.callFuncToGetUserData()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            AvatarDownloader().downloadAvatar(avatarID: "\(github.id)", size: 4) { result in
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
        
        if let count = self.dataCache.object(forKey: self.github.followers_url as NSString) {
            // print("followers_url = \(self.github.followers_url) count = \(count)")
            detailLabels.append(self.makeLabel(text: "Following: \(count)"))
        } else {
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
        }
        
        if let count = self.dataCache.object(forKey: self.github.following_url as NSString) {
            // print("following_url = \(self.github.following_url) count = \(count)")
            detailLabels.append(self.makeLabel(text: "Following: \(count)"))
        } else {
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
        }
        
        if let count = self.dataCache.object(forKey: self.github.repos_url as NSString) {
            // print("repos_url = \(self.github.repos_url) count = \(count)")
            detailLabels.append(self.makeLabel(text: "Repositories count: \(count)"))
        } else {
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
        }
        
        if let count = self.dataCache.object(forKey: self.github.gists_url as NSString) {
            // print("gists_url = \(self.github.gists_url) count = \(count)")
            detailLabels.append(self.makeLabel(text: "Gists count: \(count)"))
        } else {
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
