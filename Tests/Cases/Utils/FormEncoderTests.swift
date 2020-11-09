import XCTest
@testable import NetStack


private enum TestData {
}


final class FormEncoderTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }


    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}


// MARK: - Computed Properties
extension FormEncoderTests {

    func test_Encode_WithAlphaNumericKeysAndValues_CreatesDataFromEncodedStringThatAllowsAlphanumerics() throws {
        let formItems = [
            "name": "CypherPoet",
        ]

        let expected = Data("name=CypherPoet".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func test_Encode_WithEmojiValue_CreatesDataFromEncodedStringThatEscapesEmoji() throws {
        let formItems = [
            "name": "🦄",
        ]

        let expected = Data("name=%F0%9F%A6%84".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func test_Encode_WithEmptyValues_CreatesDataFromEncodedEmptyValueString() throws {
        let formItems = [
            "name": "",
        ]

        let expected = Data("name=".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func test_Encode_WithEmptyDictionary_CreatesDataFromEncodedEmptyString() throws {
        let formItems = [String: String]()

        let expected = Data("".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }
}
