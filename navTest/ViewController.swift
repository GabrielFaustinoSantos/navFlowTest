//
//  ViewController.swift
//  navTest
//
//  Created by Gabriel Faustino dos Santos - GSN on 29/01/20.
//  Copyright © 2020 Gabriel Faustino dos Santos - GSN. All rights reserved.
//

import UIKit

class ItemBViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class ItemAViewController: UIViewController {
    static let CUSTOM_FRAME_SIZE = CGSize(width: 100, height: 60)

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var frameLbl: UILabel!

    private let customButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                      size: ItemAViewController.CUSTOM_FRAME_SIZE))

    override func viewDidLoad() {
        super.viewDidLoad()
        customButton.backgroundColor = UIColor.red
        customButton.addTarget(self, action: #selector(didClickNavCustomButton), for: .touchUpInside)
        navigationItem.titleView = nil
        navigationItem.titleView = UIView(frame: customButton.frame)
        navigationItem.titleView?.addSubview(customButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frameLbl.text = (frameLbl.text ?? "") + "\nVIEW WILL APPEAR" + getDesc() + "\n"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        frameLbl.text = (frameLbl.text ?? "") + "\nVIEW DID APPEAR" + getDesc() + "\n"
    }

    @IBAction func didClickNext(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let view = self.storyboard?.instantiateViewController(identifier: "InternalViewController") ?? UIViewController()
            self.navigationController?.pushViewController(view, animated: true)
        } else {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "InternalViewController") ?? UIViewController()
            self.navigationController?.pushViewController(view, animated: true)
        }
    }

    @objc func didClickNavCustomButton() {
        guard let navView = navigationController!.view else { return }
        let origin = customButton.convert(customButton.frame.origin , to: navView)
        let windowSpaceView = UIView(frame: CGRect(origin: origin,
                                                   size: ItemAViewController.CUSTOM_FRAME_SIZE))
        windowSpaceView.backgroundColor = UIColor.clear
        navView.addSubview(windowSpaceView)
        windowSpaceView.ping(UIColor.green) { _ in
            windowSpaceView.removeFromSuperview()
        }
    }

    private func getDesc() -> String {
        if #available(iOS 12, *) {
            let contentDesc = navigationItem.titleView?.superview?.superview.debugDescription ?? ""
            let textDesc = navigationItem.titleView?.superview.debugDescription ?? ""
            return "\n|\nV\n\(contentDesc)\n\(textDesc)"
        } else {
            let contentDesc = navigationItem.titleView.debugDescription
            return "\n|\nV\n\(contentDesc)"
        }
    }
}

extension UIView {
    func ping(_ color: UIColor, completion: @escaping (Bool) -> Void = { _ in return }) {
        let currentColor = self.backgroundColor
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.backgroundColor = color
            self?.backgroundColor = currentColor
        }, completion: completion)
    }
}
