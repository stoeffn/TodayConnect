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

final class ReviewDetailViewController: NSViewController {

    // MARK: - User Interface

    // MARK: Properties

    var reviewSummary: ReviewSummary? {
        didSet { updateUI() }
    }

    var reviews: ReviewList? {
        didSet { updateUI() }
    }

    @objc dynamic var isExpanded: Bool = false {
        didSet { updateUI() }
    }

    // MARK: Texts

    var ratingCountText: String? {
        guard let reviewSummary = reviewSummary else { return nil }
        return "\(reviewSummary.ratingCount) ratings"
    }

    var reviewCountText: String? {
        guard let reviews = reviews else { return nil }
        return "\(reviews.reviewCount) reviews"
    }

    var detailText: String {
        return [ratingCountText, reviewCountText].compactMap { $0 }.joined(separator: " • ")
    }

    // MARK: Views

    @IBOutlet var collapseExpandButton: NSButton!

    @IBOutlet var detailLabel: NSTextField!

    // MARK: UI Cycle

    private func updateUI() {
        collapseExpandButton.title = isExpanded ? "Show Less…" : "Show More…"
        detailLabel.alphaValue = isExpanded ? 0.6 : 0
        detailLabel.stringValue = detailText
    }

    // MARK: - User Interaction

    @IBAction
    func collapseExpandButtonClicked(_: Any) {
        isExpanded = !isExpanded
    }
}
