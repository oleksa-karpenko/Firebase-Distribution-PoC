import Testing
@testable import FBDistributionPoC

struct ContentViewModelTests {
    @Test
    func testDefaultValues() {
        let viewModel = ContentViewModel()
        #expect(viewModel.getImageName() == "globe")
        #expect(viewModel.getTitle() == "Hello, world!")
        #expect(viewModel.getSubTitle() == "Playing with the Firebase Distribution!")
    }
    
    @Test
    func testCustomValues() {
        let viewModel = ContentViewModel(
            imageName: "custom.image",
            titleText: "Welcome",
            subtitleText: "Custom subtitle"
        )
        #expect(viewModel.getImageName() == "custom.image")
        #expect(viewModel.getTitle() == "Welcome")
        #expect(viewModel.getSubTitle() == "Custom subtitle")
    }
    
    @Test
    func testVersionFormat() {
        let versionProvider = MockVersionProvider(version: "3.4.5", buildNumber: "42")
        let viewModel = ContentViewModel(versionProvider: versionProvider)
        let version = viewModel.getVersion()
        #expect(version == "Version: 3.4.5 (build 42)")
        #expect(version.starts(with: "Version:"))
        #expect(version.contains("("))
        #expect(version.contains(")"))
    }
}
