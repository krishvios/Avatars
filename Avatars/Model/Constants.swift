import Foundation

extension String {
    static let gitHubUsersHost = "api.github.com/users"
    static let gitHubAvtarsHost = "avatars.githubusercontent.com"
    static let githubUsersEndpoint = "https://"+gitHubUsersHost
    static let githubUsersAvatarEndpoint = "https://"+gitHubAvtarsHost
}

extension Int {
    static let avatarSize = 100
}
