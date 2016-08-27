import Foundation

import UIKit
import RxSwift
import RxCocoa

class CombindLatestAndSampleViewController: UIViewController {
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable
            .of(textField1)
            .sample(rx_sentMessage(#selector(viewWillAppear)))
            .subscribeNext { $0.becomeFirstResponder() }
            .addDisposableTo(disposeBag)

        Observable
            .combineLatest(textField1.rx_text, textField2.rx_text) { "\($0) \($1)" }
            .sample(button.rx_tap)
            .bindTo(label.rx_text)
            .addDisposableTo(disposeBag)
    }
}
