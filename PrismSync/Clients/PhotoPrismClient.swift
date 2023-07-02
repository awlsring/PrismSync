//
//  PhotoPrismClient.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 6/30/23.
//

import Foundation

enum PhotoPrismClientError: Error {
    case noData
    case unauthorized
    case resourceNotFound
    case internalServerError(message: String)
}

class PhotoPrismClient {
    private let baseURL: URL
    private let session: URLSession
    private let username: String
    private let password: String
    
    init(baseURL: URL, username: String, password: String) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: .default)
        self.username = username
        self.password = password
    }

    private func performRequest(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        var requestWithAuth = request
        addBasicAuthHeader(request: &requestWithAuth)
        
        let task = session.dataTask(with: requestWithAuth) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(PhotoPrismClientError.internalServerError(message: "something bad happened")))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(PhotoPrismClientError.noData))
                }
            case 201:
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(PhotoPrismClientError.noData))
                }
            case 401:
                print(httpResponse.allHeaderFields)
                completion(.failure(PhotoPrismClientError.unauthorized))
            case 404:
                completion(.failure(PhotoPrismClientError.resourceNotFound))
            default:
                completion(.failure(PhotoPrismClientError.internalServerError(message: httpResponse.description)))
            }
        }
        
        task.resume()
    }
    
    func getPhoto(location: String, photoID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("\(location)/\(photoID)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        performRequest(with: request, completion: completion)
    }
    
    func uploadPhoto(location: String, photoID: String, imageData: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("\(location)/\(photoID)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        performRequest(with: request, completion: completion)
    }
    
    private func addBasicAuthHeader(request: inout URLRequest) {
        let authString = "\(username):\(password)"
        guard let authData = authString.data(using: .utf8) else { return }
        let base64AuthString = authData.base64EncodedString()
        request.setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
    }
}
