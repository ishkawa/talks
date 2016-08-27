import UIKit
import RxSwift
import RxCocoa

class BindViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable
            .of(textField)
            .sample(rx_sentMessage(#selector(viewWillAppear)))
            .subscribeNext { $0.becomeFirstResponder() }
            .addDisposableTo(disposeBag)

        textField.rx_text
            .map { "\($0.characters.count)" }
            .bindTo(label.rx_text)
            .addDisposableTo(disposeBag)
    }
}
