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

    var reviews: ReviewList? {
        didSet { updateUI() }
    }

    var isCollapsed: Bool = true {
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

    // MARK: Child Controllers

    private var reviewSummaryViewController: ReviewSummaryViewController?

    private var reviewsViewController: ReviewsViewController?

    // MARK: Views

    @IBOutlet var reviewsView: NSView!

    @IBOutlet var detailLabel: NSTextField!

    @IBOutlet var collapseExpandButton: NSButton!

    // MARK: UI Cycle

    private func updateUI() {
        reviewSummaryViewController?.reviewSummary = reviewSummary

        reviewsView.isHidden = isCollapsed
        reviewsViewController?.reviews = reviews?.reviews
            .prefix(5)
            .map { $0.value }

        collapseExpandButton.title = isCollapsed ? "Show More…" : "Show Less…"
        detailLabel.isHidden = isCollapsed
        detailLabel.stringValue = detailText
    }

    // MARK: - User Interaction

    @IBAction
    func collapseExpandButtonClicked(_ sender: Any) {
        isCollapsed = !isCollapsed
    }

    // MARK: - Navigation

    enum Segues: String {
        case reviewSummary, reviews
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier?.rawValue else { return }

        switch Segues(rawValue: identifier) {
        case .reviewSummary?:
            reviewSummaryViewController = segue.destinationController as? ReviewSummaryViewController
        case .reviews?:
            reviewsViewController = segue.destinationController as? ReviewsViewController
        case nil:
            break
        }
    }
}
