//
//  DetailViewController.swift
//  TMDB
//
//  Created by Azis Ramdhan on 01/11/21.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet private weak var backdropView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var favoriteSwitch: UISwitch!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var trailerButton: UIButton!
    
    private weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate

    private let movieDetailVM: DetailViewModel = {
        let viewModel = DetailViewModel(service: DetailDataService())
        return viewModel
    }()

    static var nibName = "ReviewCollectionViewCell"
    static var cellReuseId = "ReviewCollectionViewCell"

    var onFavoriteStatusChanged: ((Bool) -> Void)?
    var onTrailerButtonClicked: (() -> Void)?
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupCompletionHandler()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movieId = movieId, let appDelegate = appDelegate else {
            return
        }
        favoriteSwitch.isOn = movieDetailVM.isFavorites(appDelegate, id: movieId)
    }
    @IBAction func trailerTouchedUp(_ sender: Any) {
        onTrailerButtonClicked?()
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        guard let appDelegate = appDelegate else {
            return
        }
        if sender.isOn {
            movieDetailVM.addToFavorites(appDelegate)
        } else {
            guard let movieId = movieId else {
                return
            }
            movieDetailVM.removeFromFavorites(appDelegate, id: movieId)
        }
        onFavoriteStatusChanged?(sender.isOn)
    }

    private func config() {
        collectionView.register(UINib(nibName: DetailViewController.nibName, bundle: nil),
                                forCellWithReuseIdentifier: DetailViewController.cellReuseId)
        collectionView.dataSource = self
    }

    private func setupCompletionHandler() {
        movieDetailVM.onSuccessGetMovieDetail = {
            self.hideIndicatorView()
            guard let data = self.movieDetailVM.movie else {
                return
            }
            self.setup(data)
        }

        movieDetailVM.onErrorGetMovieDetail = { error in
            self.hideIndicatorView()
            self.showMessage(error) { [weak self] _ in
                guard let self = self, let movieId = self.movieId else { return }
                self.movieDetailVM.getMovieDetail(movieId)
            }
        }

        movieDetailVM.onSuccessGetReviews = {
            self.hideIndicatorView()
            self.collectionView.reloadData()
        }

        movieDetailVM.onErrorGetReviews = { error in
            self.hideIndicatorView()
            self.showMessage(error) { [weak self] _ in
                guard let self = self, let movieId = self.movieId else { return }
                self.movieDetailVM.getReviews(movieId)
            }
        }
        
        movieDetailVM.onSuccessGetVideos = {
            self.hideIndicatorView()
            self.setupVideo()
        }

        movieDetailVM.onErrorGetVideos = { error in
            self.hideIndicatorView()
            self.showMessage(error) { [weak self] _ in
                guard let self = self, let movieId = self.movieId else { return }
                self.movieDetailVM.getVideos(movieId)
            }
        }
    }

    private func fetchData() {
        showIndicatorView()
        guard let movieId = movieId else {
            return
        }

        movieDetailVM.getMovieDetail(movieId)
        movieDetailVM.getReviews(movieId)
        movieDetailVM.getVideos(movieId)
    }

    private func setup(_ data: MovieDetail) {
        titleLabel.text = data.title
        if let voteAverage = data.voteAverage {
            ratingLabel.text = String(voteAverage) + " (IMDb)"
        } else {
            ratingLabel.text = "- (IMDb)"
        }
        if let date = data.releaseDate {
            releaseDateLabel.text = DateFormatter.string(iso: date)
        } else {
            releaseDateLabel.text = "-"
        }
        synopsisLabel.text = data.overview
        if let runtime = data.runtime {
            timeLabel.text = "\(runtime) minutes"
        } else {
            timeLabel.text = "- minutes"
        }
        guard let path = data.backdropPath, let url = URL(string: "\(AppConstants.baseImageURL)/\(path)") else {
            return
        }
        fetchImageFrom(url)
    }
    
    private func setupVideo() {
        if let video = movieDetailVM.videos?.results?.first, let url = video.youtubeURL {
            trailerButton.isHidden = false
            onTrailerButtonClicked = { [weak self] in
                let vc = WebViewController()
                vc.youtubeURL = url
                self?.present(vc, animated: true, completion: nil)
            }
        } else {
            trailerButton.isHidden = true
        }
    }

    private func fetchImageFrom(_ url: URL) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        if let response = configuration.urlCache?.cachedResponse(for: URLRequest(url: url)) {
            backdropView.image = UIImage(data: response.data)
        } else {
            let downloadTask: URLSessionDataTask = session.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data else { return }

                DispatchQueue.main.async {
                    self.backdropView.image = UIImage(data: data)
                }
            }
            downloadTask.resume()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetailVM.results.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailViewController.cellReuseId,
                                                         for: indexPath) as? ReviewCollectionViewCell {
            cell.setupItem(movieDetailVM.results[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
