import XCTest

final class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-forceDarkMode"]
        app.launch()
        Thread.sleep(forTimeInterval: 3.0)
    }

    func test01_Home() throws {
        capture("01_Home")
    }

    func test02_Mirror() throws {
        tapTab(label: "Mirror")
        capture("02_Mirror")
    }

    func test03_Translate() throws {
        tapTab(label: "Translate")
        capture("03_Translate")
    }

    func test04_Rules() throws {
        tapTab(label: "Rules")
        capture("04_Rules")
    }

    func test05_Profile() throws {
        tapTab(label: "Profile")
        capture("05_Profile")
    }

    func test06_TranslatorText() throws {
        tapTab(label: "Translate")
        // Type some text to show the translation in action
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 3) {
            textField.tap()
            textField.typeText("Hello World")
            Thread.sleep(forTimeInterval: 1.0)
        }
        capture("06_Translator_Output")
    }

    func test07_MirrorControls() throws {
        tapTab(label: "Mirror")
        // Tap mirror toggle
        let buttons = app.buttons.allElementsBoundByIndex
        if buttons.count >= 2 {
            buttons[1].tap()
            Thread.sleep(forTimeInterval: 1.0)
        }
        capture("07_Mirror_Flipped")
    }

    func test08_Rules_Complete() throws {
        tapTab(label: "Rules")
        Thread.sleep(forTimeInterval: 1.0)
        capture("08_Rules_Detail")
    }

    // MARK: - Helpers

    private func tapTab(label: String) {
        let tab = app.buttons[label]
        if tab.waitForExistence(timeout: 5) {
            tab.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
    }

    private func capture(_ name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let data = screenshot.pngRepresentation
        let path = "/tmp/ReverseWorld_\(name).png"
        try? data.write(to: URL(fileURLWithPath: path))
        print("Saved: \(path) - \(data.count) bytes")
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
