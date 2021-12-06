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
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.startAnimating()
        }
    }

    func hideIndicatorView() {
        DispatchQueue.main.async {  [weak self] in
            self?.indicatorView.stopAnimating()
        }
    }
    
    func showMessage(_ message: String, action: @escaping (UIAlertAction)->Void) {
        let alert = UIAlertController(title: "Invalid Response", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: action))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }

}
