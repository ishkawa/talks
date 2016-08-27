import Foundation
import CoreLocation
import RxSwift

enum LocationStatus {
    case Authorized(CLLocation)
    case Denied
    
    var description: String {
        switch self {
        case .Authorized(let location):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "\(latitude), \(longitude)"
            
        case .Denied:
            return "位置情報の利用が許可されていません"
        }
    }
}

extension LocationStatus {
    static func requestCurrentStatus() -> Observable<LocationStatus> {
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager
            .rx_didChangeAuthorizationStatus
            .doOnNext { status in
                switch status {
                case .NotDetermined:
                    locationManager.requestWhenInUseAuthorization()

                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    locationManager.startUpdatingLocation()

                case .Denied, .Restricted:
                    break
                }
            }

        let location = locationManager
            .rx_didUpdateLocations
            .flatMap { $0.first.map { Observable.of($0) } ?? Observable.empty() }
            .doOnNext { location in
                locationManager.stopUpdatingLocation()
            }

        let authorized = location
            .map { LocationStatus.Authorized($0) }

        let denied = authorizationStatus
            .filter { $0 == .Denied || $0 == .Restricted }
            .map { _ in LocationStatus.Denied }

        return Observable
            .of(authorized, denied)
            .merge()
            .take(1)
    }
}
