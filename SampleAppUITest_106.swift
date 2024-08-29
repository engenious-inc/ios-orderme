
import XCTest

class SampleAppUITest_106: BaseTest {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testVerifyMyReservationsTabIsRestricted() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()
        let myReservationsScreen = restaurantsListScreen.tapMyReservations()

        XCTAssert(myReservationsScreen.youDidNotLoginAlert.waitForExistence(timeout: 2),
                  "You did not login alert is not present")
    }

}
