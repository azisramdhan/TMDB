//
//  DetailDataService.swift
//  TMDB
//
//  Created by Azis Ramdhan on 02/11/21.
//

import Foundation

class DetailDataService {
    func getMovieDetailWith(_ id: Int, successHandler: @escaping (MovieDetail) -> Void,
                            errorHandler: @escaping (String) -> Void) {
        var components = URLComponents(string: "\(AppConstants.baseURL)/\(id)")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: AppConstants.apiKey)
        ]
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            guard error == nil else {
                errorHandler(error!.localizedDescription)
                return
            }

            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    successHandler(response)
                }
            } catch {
                errorHandler(error.localizedDescription)
            }
        }
        task.resume()
    }

    func getReviewsWith(_ id: Int, successHandler: @escaping ([Result]) -> Void,
                        errorHandler: @escaping (String) -> Void) {
        var components = URLComponents(string: "\(AppConstants.baseURL)/\(id)/reviews")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: AppConstants.apiKey)
        ]
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            guard error == nil else {
                errorHandler(error!.localizedDescription)
                return
            }

            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Review.self, from: data)
                DispatchQueue.main.async {
                    successHandler(response.results)
                }
            } catch {
                errorHandler(error.localizedDescription)
            }
        }
        task.resume()
    }
}
