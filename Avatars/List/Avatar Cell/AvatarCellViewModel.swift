// AvatarCellViewModel.swift
//
// Copyright © 2023 Vivek Amirapu. All rights reserved.

import Foundation
import UIKit

class AvatarCellViewModel {
    
    var indexPath: IndexPath?
    var sessionDataTask:URLSessionDataTask!
    var dataCache: NSCache<NSString, AnyObject>?
    var networkService: NetworkServiceProtocol?
    
    var githubUser: GitUser? {
        didSet {
            getImage(avatarId: githubUser!.id)
        }
    }
    
    var loadAvatarImage: ((UIImage) -> Void)?
    
    func getImage(avatarId: Int) {
        /* Download Avatar and Cache it.*/
        if let Id = githubUser?.id {
            let idStr = Id.description
            if let savedImage = dataCache?.object(forKey: NSString(string: idStr)) {
                if let image = savedImage as? UIImage {
                    loadAvatarImage?(image)
                }
            }
            else {
                AvatarDownloader().downloadAvatar(avatarID: idStr, size: Constants.avatarSize) { [weak self] result in
                    switch result {
                    case .success(let img):
                        self?.dataCache?.setObject(img, forKey: String(describing: self?.githubUser?.id) as NSString)
                        self?.loadAvatarImage?(img)
                    case .failure:
                        break
                    }
                }
            }
        }
    }
    
}
