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

struct Review: Codable, Equatable {
    struct DeveloperResponse: Codable, Equatable {
        enum PendingState: String, Codable {
            case none = "NONE"
            case pending = "PENDING"
        }

        let responseId: Int
        let response: String
        let lastModified: Date
        let isHidden: Bool
        let pendingState: PendingState
    }

    let id: Int
    let rating: Int
    let title: String
    let review: String
    let nickname: String
    let storeFront: String
    let appVersionString: String
    let lastModified: Date
    let helpfulView: Int
    let totalViews: Int
    let edited: Bool
    let developerResponse: DeveloperResponse?
}
