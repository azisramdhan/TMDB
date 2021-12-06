//
//  BaseViewController.swift
//  TMDB
//
//  Created by Azis Ramdhan on 08/11/21.
//

import UIKit

class BaseViewController: UIViewController {

    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        indicatorView.center = view.center
        view.addSubview(indicatorView)
    }

    func showIndicatorView() {
        indicatorView.startAnimating()
    }

    func hideIndicatorView() {
        indicatorView.stopAnimating()
    }

}
