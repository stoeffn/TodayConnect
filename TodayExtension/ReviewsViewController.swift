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

final class ReviewsViewController: NSViewController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        updateUI()
    }

    // MARK: - User Interface

    // MARK: Properties

    var reviews: [Review]? {
        didSet { updateUI() }
    }

    // MARK: Views

    @IBOutlet var scrollView: NSScrollView!

    @IBOutlet var tableView: NSTableView!

    // MARK: Constraints

    private lazy var heightConstraint = view.heightAnchor.constraint(equalToConstant: 0)

    // MARK: UI Cycle

    private func initUI() {
        heightConstraint.isActive = true
    }

    private func updateUI() {
        tableView.reloadData()
        heightConstraint.constant = scrollView.documentView?.bounds.height ?? 0
    }
}

// MARK: - Table View Data Source and Delegate

extension ReviewsViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reviews?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier(rawValue: String(describing: ReviewTableCellView.self))
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? ReviewTableCellView else { fatalError() }
        cell.review = reviews?[row]
        return cell
    }
}
