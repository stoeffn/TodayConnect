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

@IBDesignable
final class RatingBarView: NSView {

    // MARK: - Life Cycle

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initUI()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        initUI()
    }

    // MARK: - User Interface

    override var frame: NSRect {
        didSet { updateUI() }
    }

    @IBInspectable
    var percentage: Double = 0 {
        didSet { updateUI() }
    }

    private var barLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = NSColor.black.cgColor
        return layer
    }()

    private func initUI() {
        wantsLayer = true

        layer?.backgroundColor = NSColor.gray.cgColor
        layer?.addSublayer(barLayer)

        updateUI()
    }

    private func updateUI() {
        let barWidth = CGFloat(max(min(percentage, 1), 0)) * bounds.width
        barLayer.frame = CGRect(x: 0, y: 0, width: barWidth, height: bounds.height)
    }
}
