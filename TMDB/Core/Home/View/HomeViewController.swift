//
//  HomeViewController.swift
//  TMDB
//
//  Created by Azis Ramdhan on 01/11/21.
//

import UIKit

enum MovieType: String {
    case popular = "Popular"
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated"
    case favorite = "Favorite"
}

class HomeViewController: BaseViewController {

    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet private weak var headerCollectionView: UICollectionView!

    private weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate

    private static let _nibName = "MovieCollectionViewCell"
    private static let cellReuseId = "MovieCollectionViewCell"

    private static let nibHeaderName = "HeaderCollectionViewCell"
    private static let cellHeaderReuseId = "HeaderCollectionViewCell"

    private lazy var menus: [MovieType] = [.popular, .nowPlaying, .topRated, .favorite]
    private lazy var homeVM: HomeViewModel = {
        let viewModel = HomeViewModel(service: HomeDataService())
        return viewModel
    }()

    var active: MovieType = .popular
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupCompletionHandler()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(rgb: 0xBBBBBB).withAlphaComponent(0.5),
                .font: UIFont(name: "Inter-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
            ]
        )

    }

    private func config() {
        movieCollectionView.register(UINib(nibName: HomeViewController._nibName, bundle: nil),
                      forCellWithReuseIdentifier: HomeViewController.cellReuseId)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self

        headerCollectionView.register(UINib(nibName: HomeViewController.nibHeaderName, bundle: nil),
                                      forCellWithReuseIdentifier: HomeViewController.cellHeaderReuseId)
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
    }

    private func setupCompletionHandler() {
        homeVM.onErrorGetMovies = { _ in
            self.hideIndicatorView()
        }

        homeVM.onSuccessGetMovies = {
            self.hideIndicatorView()
            self.movieCollectionView.reloadData()
        }
    }

    private func fetchData() {
        showIndicatorView()
        let index = menus.firstIndex { menu in
            menu == active
        }
        switch index {
        case 0: homeVM.getMovies(.popular)
        case 1: homeVM.getMovies(.nowPlaying)
        case 2: homeVM.getMovies(.topRated)
        case 3:
            guard let appDelegate = appDelegate else {
                return
            }
            homeVM.getFavoriteMovies(appDelegate)
        default: homeVM.getMovies(.popular)
        }
    }

    private func reset() {
        homeVM.reset()
        fetchData()
    }

    @IBAction func searchClicked(_ sender: UIButton) {

    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return menus.count
        } else {
            if active == .favorite {
                return homeVM.favorites.count
            } else {
                return homeVM.movies.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.cellHeaderReuseId,
                                                             for: indexPath) as? HeaderCollectionViewCell {
                let isActive = menus[indexPath.row] == active
                cell.setupItem(menus[indexPath.row].rawValue, isActive: isActive)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.cellReuseId,
                                                             for: indexPath) as? MovieCollectionViewCell {
                if active == .favorite {
                    cell.setupItem(homeVM.favorites[indexPath.row])
                } else {
                    cell.setupItem(homeVM.movies[indexPath.row])
                }
                return cell
            }
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == headerCollectionView {
            return CGSize(width: 100.0, height: 48.0)
        } else {
            let numberOfItemsPerRow: CGFloat = 2
            let spacingBetweenCells: CGFloat = 20
            let width = (collectionView.bounds.width - spacingBetweenCells)/numberOfItemsPerRow
            let height = width + (width/2) + 32.0
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            active = menus[indexPath.row]
            headerCollectionView.reloadData()
            reset()
        } else {
            let movieVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
            if active == .favorite {
                movieVC.movieId = homeVM.favorites[indexPath.row].value(forKey: "id") as? Int
                movieVC.onFavoriteStatusChanged = { _ in
                    self.reset()
                }
            } else {
                movieVC.movieId = homeVM.movies[indexPath.item].id
            }
            present(movieVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == movieCollectionView, indexPath.row == homeVM.movies.count - 1, active != .favorite {
            fetchData()
        }
    }
}
