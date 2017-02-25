//
//  SignUpViewController.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/10.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import UIKit

final class SignUpViewController: UITableViewController, Injectable {
    static func makeInstance(dependency: ()) -> SignUpViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! SignUpViewController
        return viewController
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    fileprivate let prefectureIndexPath = IndexPath(row: 2, section: 0)

    fileprivate var prefecture: Prefecture? {
        didSet {
            prefectureLabel.text = prefecture?.name
            prefectureLabel.textColor = .darkGray
        }
    }

    @IBAction func submitButtonDidTap(_ sender: UIButton) {
        view.endEditing(true)
        
        let form = SignUpForm(
            name: nameTextField.text ?? "",
            email: emailTextField.text ?? "",
            prefecture: prefecture)

        switch form.buildProduct() {
        case .success(let request):
            showProduct(request)

        case .failure(let error):
            indicateFormFieldError(error)
        }
    }

    private func showProduct(_ product: SignUpRequest) {
        let alertController = UIAlertController(
            title: "登録が完了しました",
            message: product.description,
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    private func indicateFormFieldError(_ error: FormFieldError<SignUpForm.FieldID>) {
        let alertController = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            switch error.fieldID {
            case .name:
                self.nameTextField.becomeFirstResponder()
            case .email:
                self.emailTextField.becomeFirstResponder()
            case .prefecture:
                self.tableView.selectRow(at: self.prefectureIndexPath, animated: true, scrollPosition: .none)
                self.tableView(self.tableView, didSelectRowAt: self.prefectureIndexPath)
            }
        }

        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case prefectureIndexPath:
            let viewController = PrefecturePickerController.makeInstance(dependency: .init(
                prefectures: Prefecture.all,
                selectedPrefecture: prefecture,
                delegate: self))

            navigationController?.pushViewController(viewController, animated: true)

        default:
            break
        }
    }
}

extension SignUpViewController: PrefecturePickerControllerDelegate {
    func prefecturePickerController(_ prefecturePickerController: PrefecturePickerController, didPick pickedPrefecture: Prefecture) {
        prefecture = pickedPrefecture
        _ = navigationController?.popViewController(animated: true)
    }
}

