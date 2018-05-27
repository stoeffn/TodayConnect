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
import TodayConnectKit

final class TodayViewController: NSViewController, NCWidgetProviding {
    private let api = ConnectApi()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        updateUI()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        api.reviewSummary(forAppId: "1317593772", platform: .iOS) { result in
            switch result {
            case let .success(reviewSummary) where reviewSummary != self.reviewSummary:
                DispatchQueue.main.async { self.reviewSummary = reviewSummary }
                completionHandler(.newData)
            case .success:
                completionHandler(.noData)
            case .failure:
                completionHandler(.failed)
            }
        }
    }

    // MARK: - User Interface

    // MARK: Properties

    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    var reviewSummary: ReviewSummary? {
        didSet { updateUI() }
    }

    // MARK: Child Controllers

    private lazy var contentViewController: TodayContentViewController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "TodayExtension"), bundle: nil)
        guard let viewController = storyboard.instantiateInitialController() as? TodayContentViewController else { fatalError() }
        return viewController
    }()

    // MARK: UI Cycle

    private func initUI() {
        view.addSubview(contentViewController.view)
        addChildViewController(contentViewController)

        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func updateUI() {
        contentViewController.reviewSummary = reviewSummary
    }
}
