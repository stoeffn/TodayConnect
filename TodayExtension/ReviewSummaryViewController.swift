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

final class ReviewSummaryViewController: NSViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - User Interface

    // MARK: Properties

    var reviewSummary: ReviewSummary? {
        didSet { updateUI() }
    }

    // MARK: Views

    @IBOutlet var ratingLabel: NSTextField!

    @IBOutlet var fiveStarRatingBar: RatingBarView!

    @IBOutlet var fiveStarRatingLabel: NSTextField!

    @IBOutlet var fourStarRatingBar: RatingBarView!

    @IBOutlet var fourStarRatingLabel: NSTextField!

    @IBOutlet var threeStarRatingBar: RatingBarView!

    @IBOutlet var threeStarRatingLabel: NSTextField!

    @IBOutlet var twoStarRatingBar: RatingBarView!

    @IBOutlet var twoStarRatingLabel: NSTextField!

    @IBOutlet var oneStarRatingBar: RatingBarView!

    @IBOutlet var oneStarRatingLabel: NSTextField!

    private var ratingLabels: [NSTextField] {
        return [fiveStarRatingLabel, fourStarRatingLabel, threeStarRatingLabel, twoStarRatingLabel, oneStarRatingLabel]
    }

    private var ratingBars: [RatingBarView] {
        return [fiveStarRatingBar, fourStarRatingBar, threeStarRatingBar, twoStarRatingBar, oneStarRatingBar]
    }

    // MARK: Formatters

    private lazy var ratingNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    // MARK: UI Cycle

    private func updateUI() {
        guard let reviewSummary = reviewSummary else {
            ratingLabel.stringValue = "—"
            ratingLabels.forEach { $0.stringValue = "—" }
            ratingBars.forEach { $0.percentage = 0 }
            return
        }

        ratingLabel.stringValue = ratingNumberFormatter.string(from: NSNumber(value: reviewSummary.averageRating)) ?? "—"

        fiveStarRatingLabel.integerValue = reviewSummary.ratingFiveCount
        fourStarRatingLabel.integerValue = reviewSummary.ratingFourCount
        threeStarRatingLabel.integerValue = reviewSummary.ratingThreeCount
        twoStarRatingLabel.integerValue = reviewSummary.ratingTwoCount
        oneStarRatingLabel.integerValue = reviewSummary.ratingOneCount

        fiveStarRatingBar.percentage = Double(reviewSummary.ratingFiveCount) / Double(reviewSummary.ratingCount)
        fourStarRatingBar.percentage = Double(reviewSummary.ratingFourCount) / Double(reviewSummary.ratingCount)
        threeStarRatingBar.percentage = Double(reviewSummary.ratingThreeCount) / Double(reviewSummary.ratingCount)
        twoStarRatingBar.percentage = Double(reviewSummary.ratingTwoCount) / Double(reviewSummary.ratingCount)
        oneStarRatingBar.percentage = Double(reviewSummary.ratingOneCount) / Double(reviewSummary.ratingCount)
    }
}
