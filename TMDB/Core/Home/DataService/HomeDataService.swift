//
//  HomeDataService.swift
//  TMDB
//
//  Created by Azis Ramdhan on 01/11/21.
//

import Foundation

enum RequestType: String {
    case popular = "popular"
    case topRated = "top_rated"
    case nowPlaying = "now_playing"
}

class HomeDataService {
    func getPopularMoviesWith(_ type: RequestType, page: Int,
                              successHandler: @escaping ([Movie]) -> Void, errorHandler: @escaping (String) -> Void) {

        var components = URLComponents(string: "\(AppConstants.baseURL)/\(type.rawValue)")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: AppConstants.apiKey),
            URLQueryItem(name: "page", value: String(page))
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
                let response = try decoder.decode(MovieResponse.self, from: data)
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
