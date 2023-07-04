import XCTest

class AvatarsTests: XCTestCase {

    private var avatarDownloaderMock: AvatarDownloader?

    override func setUp() {
        self.avatarDownloaderMock = AvatarDownloader()
    }

    func testDownloadAvatar() {
        let asyncDone = expectation(description: "Async function")
        let githubUserId = "6"
        var completionResult: (Result<UIImage, Error>)?
        
        self.avatarDownloaderMock?.downloadAvatar(avatarID: githubUserId, size: 4) { result in
            completionResult = result
            asyncDone.fulfill()
        }

        wait(for: [asyncDone], timeout: 10)
        /* Test the results here */
        switch completionResult {
        case .success(let img):
            XCTAssertEqual(img, nil)
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
