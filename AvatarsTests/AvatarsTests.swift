import XCTest

class AvatarsTests: XCTestCase {

    private var avatarDownloaderMock: AvatarDownloader?

    override func setUp() {
        self.avatarDownloaderMock = AvatarDownloader()
    }

    func testDownloadAvatar() {
        
        // Given
        let asyncDone = expectation(description: "Async function")
        let githubUserId = "6"
        var completionResult: (Result<UIImage, Error>)?
        
        // When
        self.avatarDownloaderMock?.downloadAvatar(avatarID: githubUserId, size: 4) { result in
            completionResult = result
            asyncDone.fulfill()
        }

        wait(for: [asyncDone], timeout: 10)
        
        // Act
        switch completionResult {
        case .success(let img):
            XCTAssertNotNil(img, "Image downloaded successfully.")
            break
        case .failure:
            XCTAssert(false)
            break
        case .none:
            XCTAssert(true)
        }
    }

    override func tearDown() {
        self.avatarDownloaderMock = nil
    }
}
