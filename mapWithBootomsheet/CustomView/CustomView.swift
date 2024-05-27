//
//  CustomView.swift
//  mapWithBootomsheet
//
//  Created by Mohamed abdelhamed on 24/05/2024.
//

import UIKit

protocol CustomViewProtocol: AnyObject {
    func isScrolledToTop()
}

class CustomView: BottomSheetView {
    
    @IBOutlet weak var scrollView: UIScrollView!

    let nibName = "CustomView"
    var contentView: UIView?
    weak var customViewDelegate: CustomViewProtocol?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        scrollView.delegate = self
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}

extension CustomView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if isScrolledToTop(scrollView: scrollView) {
               customViewDelegate?.isScrolledToTop()
           }
       }
    
       func isScrolledToTop(scrollView: UIScrollView) -> Bool {
           return scrollView.contentOffset.y <= 0
       }
}
