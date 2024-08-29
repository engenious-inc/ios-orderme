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

    func testVerifyMyReservationsTabIsRestricted() {{
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()
        let myReservationsScreen = restaurantsListScreen.tapMyReservations()

        XCTAssert(myReservationsScreen.youDidNotLoginAlert.waitForExistence(timeout: 2),
                  "You did not login alert is not present")
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
