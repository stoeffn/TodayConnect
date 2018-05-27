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

final class OlympusApi {
    private static let defaultBaseUrl = URL(string: "https://olympus.itunes.apple.com/v1/")!

    private let api: Api<OlympusApiRoutes>

    // MARK: - Life Cycle

    init(api: Api<OlympusApiRoutes>) {
        self.api = api
    }

    convenience init(baseUrl: URL = defaultBaseUrl, session: URLSession = .shared) {
        let api = Api<OlympusApiRoutes>(baseUrl: baseUrl, session: session)
        self.init(api: api)
    }

    // MARK: - Retrieving App Information

    @discardableResult
    func appConfig(forHost host: String, completion: @escaping ResultHandler<AppConfig>) -> URLSessionTask {
        return api.request(.appConfiguration(host: host)) { (result: ApiResult<AppConfig>) in
            completion(result.map { $0.value })
        }
    }
}
