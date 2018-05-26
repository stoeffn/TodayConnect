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
import NotificationCenter

final class TodayViewController: NSViewController, NCWidgetProviding {

    // MARK: - Life Cycle

    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    // MARK: - User Interface

    @IBOutlet var ratingLabel: NSTextField!

    @IBOutlet var fiveStarRatingBar: NSView!

    @IBOutlet var fiveStarRatingLabel: NSTextField!

    @IBOutlet var fourStarRatingBar: NSView!

    @IBOutlet var fourStarRatingLabel: NSTextField!

    @IBOutlet var threeStarRatingBar: NSView!

    @IBOutlet var threeStarRatingLabel: NSTextField!

    @IBOutlet var twoStarRatingBar: NSView!

    @IBOutlet var twoStarRatingLabel: NSTextField!

    @IBOutlet var oneStarRatingBar: NSView!

    @IBOutlet var oneStarRatingLabel: NSTextField!

    private var ratingBars: [NSView] {
        return [
            oneStarRatingBar,
            twoStarRatingBar,
            threeStarRatingBar,
            fourStarRatingBar,
            fiveStarRatingBar,
        ]
    }

    private func initUI() {
        for view in ratingBars {
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.gray.cgColor
        }
    }
}
