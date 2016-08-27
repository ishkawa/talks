import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class RxGeoWeatherViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let locationStatus = button.rx_tap
            .flatMap { LocationStatus.requestCurrentStatus() }
            .shareReplay(1)

        let weather = locationStatus
            .flatMap { status -> Observable<Weather?> in
                switch status {
                case .Authorized(let location):
                    return WeatherAPI.get(location: location).map(Optional.init)

                case .Denied:
                    return Observable.of(.None)
                }
            }
            .shareReplay(1)

        locationStatus
            .map { $0.description }
            .sample(weather)
            .bindTo(locationLabel.rx_text)
            .addDisposableTo(disposeBag)

        weather
            .map { $0?.description ?? "-" }
            .bindTo(weatherLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
}
