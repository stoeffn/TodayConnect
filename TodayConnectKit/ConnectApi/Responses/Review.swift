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

public struct Review: Codable, Equatable {
    public struct DeveloperResponse: Codable, Equatable {
        public enum PendingState: String, Codable {
            case none = "NONE"
            case pending = "PENDING"
        }

        public let responseId: Int
        public let response: String
        public let lastModified: Date
        public let isHidden: Bool
        public let pendingState: PendingState
    }

    public let id: Int
    public let rating: Int
    public let title: String
    public let review: String
    public let nickname: String
    public let storeFront: String
    public let appVersionString: String
    public let lastModified: Date
    public let helpfulViews: Int
    public let totalViews: Int
    public let edited: Bool
    public let developerResponse: DeveloperResponse?
}
