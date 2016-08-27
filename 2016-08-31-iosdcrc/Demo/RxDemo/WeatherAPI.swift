import Foundation
import CoreLocation
import RxSwift

final class WeatherAPI {
    static func get(location location: CLLocation, handler: Weather -> Void) {
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        dispatch_after(time, dispatch_get_main_queue()) {
            handler(Weather.random)
        }
    }

    static func get(location location: CLLocation) -> Observable<Weather> {
        let trigger = Observable<Int>
            .interval(1.0, scheduler: MainScheduler.instance)
            .take(1)

        return Observable
            .of(Weather.random)
            .sample(trigger)
    }
}
