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

public final class DefaultsCookieStorage: HTTPCookieStorage {
    private let defaults: UserDefaults

    // MARK: - Life Cycle

    public init(defaults: UserDefaults = App.userDefaults) {
        self.defaults = defaults
    }

    // MARK: - Merging Cookies

    private func mergedCookies(oldCookies: [HTTPCookie], newCookies: [HTTPCookie]) -> [HTTPCookie] {
        let cookies = oldCookies + newCookies
        let mergedCookies = Dictionary(cookies.map { ($0.name, $0) }) { _, second in second }
        return Array(mergedCookies.values)
    }

    // MARK: - Retrieving Cookies

    private func cookies(from defaults: UserDefaults) -> [HTTPCookie] {
        guard let rawCookies = defaults.array(forKey: App.UserDefaultsKeys.cookies.rawValue) as? [[String: Any]] else { return [] }
        return rawCookies.compactMap(HTTPCookie.init)
    }

    public override func getCookiesFor(_: URLSessionTask, completionHandler: @escaping ([HTTPCookie]?) -> Void) {
        completionHandler(cookies(from: defaults))
    }

    // MARK: - Storing Cookies

    private func store(cookies: [HTTPCookie], to defaults: UserDefaults) {
        defaults.set(cookies.map { $0.stringProperties }, forKey: App.UserDefaultsKeys.cookies.rawValue)
    }

    public override func storeCookies(_ newCookies: [HTTPCookie], for _: URLSessionTask) {
        store(cookies: mergedCookies(oldCookies: cookies(from: defaults), newCookies: newCookies), to: defaults)
    }
}
