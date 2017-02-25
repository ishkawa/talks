//
//  PrefecturePickerController.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2017/02/19.
//  Copyright © 2017 Yosuke Ishikawa. All rights reserved.
//

import UIKit

protocol PrefecturePickerControllerDelegate: class {
    func prefecturePickerController(
        _ prefecturePickerController: PrefecturePickerController,
        didPick prefecture: Prefecture)
}

final class PrefecturePickerController: UITableViewController, Injectable {
    struct Dependency {
        let prefectures: [Prefecture]
        let selectedPrefecture: Prefecture?
        let delegate: PrefecturePickerControllerDelegate?
    }

    static func makeInstance(dependency: Dependency) -> PrefecturePickerController {
        let storyboard = UIStoryboard(name: "PrefecturePicker", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! PrefecturePickerController
        viewController.dependency = dependency

        return viewController
    }

    private var dependency: Dependency!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToSelectedPrefecture()
    }

    private func scrollToSelectedPrefecture() {
        guard
            let selectedPrefecture = dependency.selectedPrefecture,
            let row = dependency.prefectures.index(of: selectedPrefecture) else {
            return
        }

        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.prefectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Prefecture", for: indexPath)
        let prefecture = dependency.prefectures[indexPath.row]
        cell.textLabel?.text = prefecture.name

        let isSelected = prefecture == dependency.selectedPrefecture
        cell.accessoryType = isSelected ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prefecture = dependency.prefectures[indexPath.row]
        dependency.delegate?.prefecturePickerController(self, didPick: prefecture)
    }
}
