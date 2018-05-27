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

import NotificationCenter

extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler completion: @escaping (NCUpdateResult) -> Void) {
        let group = DispatchGroup()
        var results: [NCUpdateResult] = []

        func addResult(_ result: NCUpdateResult) {
            results.append(result)
            group.leave()
        }

        group.enter()
        updateReviewSummary(completion: addResult)

        group.enter()
        updateReviews(completion: addResult)

        group.notify(queue: .main) {
            let result = results.reduce(NCUpdateResult.failed) { (result, newResult) -> NCUpdateResult in
                switch (result, newResult) {
                case (_, .newData): return .newData
                case (.newData, _): return .newData
                case (_, .noData): return .noData
                case (.noData, _): return .noData
                default: return .failed
                }
            }

            completion(result)
        }
    }

    func updateReviewSummary(completion: @escaping (NCUpdateResult) -> Void) {
        api.reviewSummary(forAppId: appId, platform: platform) { result in
            switch result {
            case let .success(reviewSummary) where reviewSummary != self.reviewSummary:
                DispatchQueue.main.async { self.reviewSummary = reviewSummary }
                completion(.newData)
            case .success:
                completion(.noData)
            case .failure:
                completion(.failed)
            }
        }
    }

    func updateReviews(completion: @escaping (NCUpdateResult) -> Void) {
        api.reviews(forAppId: appId, platform: platform) { result in
            switch result {
            case let .success(reviews) where reviews != self.reviews:
                DispatchQueue.main.async { self.reviews = reviews }
                completion(.newData)
            case .success:
                completion(.noData)
            case .failure:
                completion(.failed)
            }
        }
    }
}
