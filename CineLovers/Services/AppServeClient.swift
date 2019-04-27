//
//  AppServeClient.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 25/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - AppServerClient
class AppServerClient: ApiService {

    var parameters: Parameters = [
        "api_key": "1f54bd990f1cdfb230adb312546d765d",
        "page": 0
    ]
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    // MARK: - GetUpcomingMovie
    enum GetUpcomingMovieFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    func GetUpcomingMovie(pageAt page: Int?) -> Observable<MovieViewModel> {
        if let hasPage = page {
            self.parameters["page"] = hasPage
        }
        return Observable.create { observer -> Disposable in
            Alamofire.request(Constants.ApiClient.ApiUrlBase + Constants.ApiClient.UpcomingMovieUrl, method: .get, parameters: self.parameters, encoding: URLEncoding(destination: .queryString), headers:self.headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            // .notFound should never happen here?
                            observer.onError(response.error ?? GetUpcomingMovieFailureReason.notFound)
                            return
                        }
                        do {
                            let movies = try JSONDecoder().decode(MovieViewModel.self, from: data)
                            observer.onNext(movies)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = GetUpcomingMovieFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }
}
