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

public final class ConnectApi {
    public static let defaultBaseUrl = URL(string: "https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/")!
    public static let defaultCookieStorage = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: App.groupIdentifier)

    private let api: Api<ConnectApiRoutes>
    private let olympusApi: OlympusApi

    // MARK: - Life Cycle

    init(api: Api<ConnectApiRoutes>, olympusApi: OlympusApi = OlympusApi()) {
        self.api = api
        self.olympusApi = olympusApi
    }

    public convenience init(baseUrl: URL = defaultBaseUrl, cookieStorage: HTTPCookieStorage = defaultCookieStorage) {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = cookieStorage
        let session = URLSession(configuration: configuration)

        let api = Api<ConnectApiRoutes>(baseUrl: baseUrl, session: session)
        self.init(api: api)
    }

    // MARK: - Authorization

    @discardableResult
    public func authorizationApi(completion: @escaping ResultHandler<AuthorizationApi>) -> URLSessionTask {
        guard let host = api.baseUrl.host else {
            fatalError("Cannot retrieve host from URL '\(api.baseUrl)'.")
        }

        return olympusApi.appConfig(forHost: host) { result in
            completion(result.map { AuthorizationApi(appConfig: $0, cookieStorage: ConnectApi.defaultCookieStorage) })
        }
    }

    // MARK: - Reviews

    @discardableResult
    public func reviewSummary(forAppId appId: String, platform: Platforms, countryCode: String,
                              completion: @escaping ResultHandler<ReviewSummaryResponse>) -> URLSessionTask {
        let route = ConnectApiRoutes.reviewSummary(appId: appId, platform: platform, countryCode: countryCode)
        return api.request(route) { (result: ApiResult<ConnectResponse<ReviewSummaryResponse>>) in
            completion(result.map { $0.value.data })
        }
    }
}
