
import XCTest

class SampleAppUITest_0: BaseTest {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testVerifyMyReservationsTabIsRestricted() {
        let randomValue = arc4random_uniform(2)

        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()

        if randomValue == 0 {
            let myReservationsScreen = restaurantsListScreen.tapMyReservations()
            XCTAssert(myReservationsScreen.youDidNotLoginAlert.waitForExistence(timeout: 2),
                      "You did not login alert is not present")
        } else {
            XCTFail("You did not login alert is not present")
        }
    }

}
