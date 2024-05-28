import UIKit

class CustomView: BottomSheetView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!

    let nibName = "CustomView"
    var contentView: UIView?

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
        
        // Set the gesture recognizer delegate
        if let panGesture = self.gestureRecognizers?.first as? UIPanGestureRecognizer {
            panGesture.delegate = self
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    // Override the gesture recognizer delegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // New method to determine if the pan gesture should be recognized
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if scrollView.contentOffset.y <= 0 {
            scrollView.isScrollEnabled = false
            return true
        } else {
            scrollView.isScrollEnabled = true
            return false
        }
    }
    
    // UIScrollViewDelegate method to handle when the scroll view scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
}
