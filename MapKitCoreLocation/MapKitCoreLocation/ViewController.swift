import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            updateLocationonMap(to: location, with: "My Location")
        }
    }

    func updateLocationonMap(to location: CLLocation, with title: String?) {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate

        mapView.removeAnnotations(mapView.annotations) // Corrigindo o erro aqui

        mapView.addAnnotation(point)

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }

    @IBAction func onLocationButtonTapped() {
        updateLocationonMap(to:locationManager.location ?? CLLocation(), with: "Test Location")
    }
}


