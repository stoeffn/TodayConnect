//
//  TodayConnect
//
//  Copyright © 2018 Steffen Ryll
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//  modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Cocoa
import TodayConnectKit

final class ViewController: NSViewController {
    private let api = ConnectApi()

    @IBOutlet var emailTextField: NSTextField!

    @IBOutlet var passwordTextfield: NSSecureTextField!

    @IBOutlet var securityCodeTextField: NSSecureTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        api.refreshConfiguration { print($0) }
    }

    @IBAction
    func logIn(_ sender: Any) {
        api.login(email: emailTextField.stringValue, password: passwordTextfield.stringValue) { print($0) }
    }

    @IBAction
    func verifyDevice(_ sender: Any) {
        api.verifyDevice(securityCode: securityCodeTextField.stringValue) { result in
            print(result)

            self.api.trust { result in
                print(result)
                self.api.test(completion: { result in
                    print(result)
                })
            }
        }
    }
}
