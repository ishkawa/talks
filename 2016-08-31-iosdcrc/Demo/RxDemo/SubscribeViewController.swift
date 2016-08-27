import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable
            .of(textField)
            .sample(rx_sentMessage(#selector(viewWillAppear)))
            .subscribeNext { $0.becomeFirstResponder() }
            .addDisposableTo(disposeBag)

        textField.rx_text
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
    }
}
