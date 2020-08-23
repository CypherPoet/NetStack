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

    func testFormEncoder_encode_withAlphaNumericKeysAndValues_createsDataFromEncodedStringThatAllowsAlphanumerics() throws {
        let formItems = [
            "name": "CypherPoet",
        ]

        let expected = Data("name=CypherPoet".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func testFormEncoder_encode_withEmojiValue_createsDataFromEncodedStringThatEscapesEmoji() throws {
        let formItems = [
            "name": "🦄",
        ]

        let expected = Data("name=%F0%9F%A6%84".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func testFormEncoder_encode_withEmptyValues_createsDataFromEncodedEmptyValueString() throws {
        let formItems = [
            "name": "",
        ]

        let expected = Data("name=".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }


    func testFormEncoder_encode_withEmptyDictionary_createsDataFromEncodedEmptyString() throws {
        let formItems = [String: String]()

        let expected = Data("".utf8)
        let actual = FormEncoder.encode(formItems: formItems)

        XCTAssertEqual(actual, expected)
    }
}
