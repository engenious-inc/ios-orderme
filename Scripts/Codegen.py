# Codegen.py
import os
import sys

def generate_test_files(num_files, possibility):
    for i in range(num_files):
        with open(f"SampleAppUITest_{i}.swift", 'w') as file:
            file.write(f'''
import XCTest

class SampleAppUITest_{i}: BaseTest {{

    override func setUp() {{
        super.setUp()
        app.launch()
    }}

    override func tearDown() {{
        super.tearDown()
    }}

func testBringAMenu() throws {{
    let app = XCUIApplication()
    app.launch()

    let loginLaterButton = app.buttons["loginLaterButton"]
    loginLaterButton.tap()

    let republiqueRest = app.staticTexts["Republique"]
    republiqueRest.tap()

    let detectTableOption = app.collectionViews.staticTexts["Detect table"]
    detectTableOption.tap()

    let tableNumberField = app.textFields["tableNumberTextField"]
    tableNumberField.tap()
    tableNumberField.typeText("3")
    let selectTableButton = app.buttons["Select table"]
    selectTableButton.tap()

    let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
    callAWaiterOption.tap()

    let waiterAlert = app.alerts["The waiter is on his way"]
    let bringAMenuButton = waiterAlert.buttons["Bring a menu"]
    bringAMenuButton.tap()

    let gotItAlert = app.alerts["Got it!"]
    XCTAssert(gotItAlert.waitForExistence(timeout: 2), "Got it alert is not present")

    callAWaiterOption.tap()

    let bringTheBillButton = waiterAlert.buttons["Bring the bill"]
    bringTheBillButton.tap()

    XCTAssert(gotItAlert.waitForExistence(timeout: 2), "Got it alert is not present")

    let restaurantScreen = RestaurantScreen()
    restaurantScreen.choose(option: .callRestaurant)

    XCTAssert(restaurantScreen.callAlert.waitForExistence(timeout: 2),
         "Call alert is not present")
  }}

}}
''')


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py [number_of_files, possibility]")
        sys.exit(1)
    try:
        num_files = int(sys.argv[1])
        possibility = int(sys.argv[2])
    except ValueError:
        print("Invalid args")
        sys.exit(1)

    generate_test_files(num_files, possibility)
    print('All test files generated.')  
