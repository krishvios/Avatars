
import UIKit

class AvatarDownloader {
    func downloadAvatar(avatarID: String, size: Int, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var componenets = URLComponents(string: .githubUsersAvatarEndpoint + "/" + "u" + "/" + "\(avatarID)")
        componenets?.queryItems = [
            URLQueryItem(name: "v", value: "\(size)")
        ]
        guard let imageUrl = componenets?.url else { return }

        let request = URLRequest(url: imageUrl)
        print("imageUrl = \(imageUrl)")
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error as NSError? {
                completion(.failure(error as Error))
            } else if let data, let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
        dataTask.resume()
    }
}



