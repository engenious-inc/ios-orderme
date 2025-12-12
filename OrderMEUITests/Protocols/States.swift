import XCTest

protocol States: Initializable {
    var exists: Bool { get }
    var selected: Bool { get }
}

enum ElementStateType: String {
    case exist
    case selected
}

extension States {
    var exists: Bool {
        element.exists
    }

    var selected: Bool {
        element.isSelected
    }
}

extension States {
    @discardableResult
    func assert(state: ElementStateType = .exist, result: Bool = true, message: String? = nil) -> Self? {
        let timeout: TimeInterval = defaultTimeout
        var conditionMet = false

        switch state {
        case .exist:
            conditionMet = element.waitForExistence(timeout: timeout) == result
        case .selected:
            conditionMet = element.isSelected == result
        }

        XCTAssert(conditionMet, message ?? #"Element: "\#(description)" state: "\#(state.rawValue)" is not equal to "\#(result)"."#)
        return self
    }
}
