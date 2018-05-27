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

final class TodayContentViewController: NSViewController {
    // MARK: - User Interface

    // MARK: Properties

    var reviewSummary: ReviewSummary? {
        didSet { updateUI() }
    }

    // MARK: Child Controllers

    private var reviewSummaryViewController: ReviewSummaryViewController?

    // MARK: UI Cycle

    private func updateUI() {
        reviewSummaryViewController?.reviewSummary = reviewSummary
    }

    // MARK: - Navigation

    enum Segues: String {
        case reviewSummary
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier?.rawValue else { return }

        switch Segues(rawValue: identifier) {
        case .reviewSummary?:
            reviewSummaryViewController = segue.destinationController as? ReviewSummaryViewController
        case nil:
            break
        }
    }
}
