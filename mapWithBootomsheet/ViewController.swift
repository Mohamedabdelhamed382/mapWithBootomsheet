import UIKit
import MapKit

class ViewController: UIViewController {

    let mapView = MKMapView()
    let bottomSheetView = CustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupBottomSheet()
        bottomSheetView.bottomSheetViewDelegate = self

    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBottomSheet() {
        bottomSheetView.attach(to: view, minHeightRatio: 0.25, maxHeightRatio: 0.75)
    }
}

extension ViewController: BottomSheetViewProtocol {
    func bottomSheetSettled(position: BottomSheetPosition) {
        switch position {
        case .top:
            print("Bottom sheet is at the top position")
            
        case .down:
            print("Bottom sheet is at the down position")
        }
    }
}
