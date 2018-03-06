//
//  HorizontalScrollerView.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/03/01.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

protocol HorizontalScrollerViewDataSource: class {
    /// Ask the data source how many views it wants to present inside the horizontal scroller
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int

    /// Ask the data source to return the view that should appear at <index>
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}

protocol HorizontalScrollerViewDelegate: class {
    /// inform the delegate that the view at <index> has been selected
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}

class HorizontalScrollerView: UIView {

    weak var dataSource: HorizontalScrollerViewDataSource?
    weak var delegate: HorizontalScrollerViewDelegate?

    /// Define a private enum to make it easy to modify the layout at design time.
    /// The view’s dimensions inside the scroller will be 100 x 100 with a 10 point margin
    /// from its enclosing rectangle.
    private enum ViewControllers {
        static let Padding: CGFloat = 10
        static let Dimensions: CGFloat = 100
        static let Offset: CGFloat = 100
    }

    /// Create the scroll view containing the views.
    private let scroller = UIScrollView()

    /// Create an array that holds all the album covers.
    private var contentViews = [UIView]()

    /// MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }

    func initializeScrollView() {
        // Adds the UIScrollView instance to the parent view.
        self.addSubview(scroller)
        // Turn off autoresizing masks. This is so you can apply your own constraints
        scroller.translatesAutoresizingMaskIntoConstraints = false
        // Apply constraints to the scrollview. You want the scroll view
        // to completely fill the HorizontalScrollerView
        NSLayoutConstraint.activate([
            scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroller.topAnchor.constraint(equalTo: self.topAnchor),
            scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped))
        scroller.addGestureRecognizer(tapGesture)
        scroller.delegate = self
    }

    /// Finds the location of the tap in the scroll view,
    /// then the index of the first content view that contains that location.
    /// If a content view was hit, the delegate is informed and the view is scrolled to the center.
    @objc func scrollerTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scroller)
        guard
            let index = contentViews.index(where: { $0.frame.contains(location) })
            else { return }
        delegate?.horizontalScrollerView(self, didSelectViewAt: index)
        scrollToView(at: index)
    }

    /// Retrieves the view for a specific index and centers it.
    func scrollToView(at index: Int, animated: Bool = true) {
        let contentView = contentViews[index]
        let targetCenter = contentView.center
        let targetOffsetX = targetCenter.x - scroller.bounds.width / 2
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
    }

    func view(at index: Int) -> UIView {
        return contentViews[index]
    }

    func reload() {
        /// Checks to see if there is a data source before we perform any reload.
        guard
            let dataSource = self.dataSource
            else { return }

        /// Since you're clearing the album covers,
        /// you also need to remove any existing views.
        contentViews.forEach({ $0.removeFromSuperview() })

        /// xValue is the starting point of each view inside the scroller
        var xValue = ViewControllers.Offset

        /// Fetch and add the new views
        contentViews = (0..<dataSource.numberOfViews(in: self)).map {
            (index: Int) -> UIView in

            /// add a view at the right position
            xValue += ViewControllers.Padding
            let contentView = dataSource.horizontalScrollerView(self, viewAt: index)
            contentView.frame = CGRect(x: xValue,
                                       y: ViewControllers.Padding,
                                       width: ViewControllers.Dimensions,
                                       height: ViewControllers.Dimensions)
            scroller.addSubview(contentView)
            xValue += ViewControllers.Dimensions + ViewControllers.Padding

            return contentView
        }

        /// Once all the views are in place,
        /// set the content offset for the scroll view to allow the user to scroll
        /// through all the albums covers.
        scroller.contentSize = CGSize(width: xValue + ViewControllers.Offset, height: frame.size.height)
    }

    func centerCurrentView() {
        let currentRect = CGRect(origin: CGPoint(x: scroller.bounds.midX, y: 0),
                                 size: CGSize(width: ViewControllers.Padding, height: bounds.height))
        guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(currentRect) })
            else { return }
        let centralView = contentViews[selectedIndex]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - ( scroller.bounds.width / 2 )

        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
    }

}

extension HorizontalScrollerView: UIScrollViewDelegate {
    /// Informs the delegate when the user finishes dragging.
    /// The decelerate parameter is true if the scroll view hasn't come to a complete stop yet.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentView()
    }

}
