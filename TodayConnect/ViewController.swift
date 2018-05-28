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
    private var authorizationApi: AuthorizationApi?

    @IBOutlet var emailTextField: NSTextField!

    @IBOutlet var passwordTextfield: NSSecureTextField!

    @IBOutlet var securityCodeTextField: NSSecureTextField!

    @IBOutlet var verifyButton: NSButton!

    @IBOutlet var appIdTextField: NSTextField!

    @IBOutlet var countryCodeTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        appIdTextField.stringValue = App.userDefaults.string(forKey: App.UserDefaultsKeys.appId.rawValue) ?? ""
        countryCodeTextField.stringValue = App.userDefaults.string(forKey: App.UserDefaultsKeys.countryCode.rawValue) ?? ""

        api.authorizationApi { self.authorizationApi = $0.value }
    }

    @IBAction
    func logIn(_: Any) {
        guard let authorizationApi = authorizationApi else {
            api.authorizationApi { self.authorizationApi = $0.value }

            let alert = NSAlert()
            alert.messageText = "Authorization API not Available—Please Try Again!"
            return alert.beginSheetModal(for: view.window!, completionHandler: nil)
        }

        authorizationApi.logIn(email: emailTextField.stringValue, password: passwordTextfield.stringValue) { result in
            let alert = NSAlert()

            switch result.error {
            case nil:
                self.authorizationApi?.trust { _ in }
                alert.messageText = "Logged in Successfully."
            case AuthorizationApi.Errors.invalidCredentials?:
                let alert = NSAlert()
                alert.messageText = "Inavlid Apple-ID or Password."
            case AuthorizationApi.Errors.requiresSecurityCode?:
                return DispatchQueue.main.async {
                    self.verifyButton.isEnabled = true
                }
            default:
                alert.messageText = "Unimplemented Response Handler."
            }

            DispatchQueue.main.async {
                alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            }
        }
    }

    @IBAction
    func verifySecurityCode(_: Any) {
        authorizationApi?.verifySecurityCode(code: securityCodeTextField.stringValue) { result in
            let alert = NSAlert()

            switch result.error {
            case nil:
                self.authorizationApi?.trust { _ in }
                alert.messageText = "Logged in Successfully."
            case AuthorizationApi.Errors.invalidSecurityCode?:
                alert.messageText = "Invalid Security Code."
            default:
                alert.messageText = "Unimplemented Response Handler."
            }

            DispatchQueue.main.async {
                alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            }
        }
    }

    @IBAction
    func updateSettings(_: Any) {
        App.userDefaults.set(appIdTextField.stringValue.nilWhenEmpty, forKey: App.UserDefaultsKeys.appId.rawValue)
        App.userDefaults.set(countryCodeTextField.stringValue.nilWhenEmpty, forKey: App.UserDefaultsKeys.countryCode.rawValue)
    }
}
