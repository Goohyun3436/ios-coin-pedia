//
//  NetworkManager.swift
//  ios-coin-pedia
//
//  Created by Goo on 3/7/25.
//

import Foundation
import RxSwift

typealias Parameters = [String: String]
typealias HTTPHeaders = [String: String]

protocol APIRequest {
    var endpoint: String { get }
    var parameters: Parameters { get }
    var headers: HTTPHeaders { get }
}

protocol APIError: Error {
    var message: String { get }
    init(statusCode: Int)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<ResponseType: Decodable, ErrorType: APIError>(
        _ request: APIRequest,
        _ responseT: ResponseType.Type,
        _ errorT: ErrorType.Type
    ) -> Single<Result<ResponseType, ErrorType>> {
        
        return Single<Result<ResponseType, ErrorType>>.create { observer in
            let disposables = Disposables.create()
            
            guard let urlRequest = self.setupRequest(request) else {
                print("======urlRequest======")
                observer(.success(.failure(ErrorType(statusCode: 0))))
                return disposables
            }
            
            print(urlRequest)
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, err in
                
                if let _ = err {
                    print("======err======")
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                guard let data else {
                    print("======data======")
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("======response======")
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                    return
                }
                
                guard (200...299).contains(response.statusCode) else {
                    print("======statusCode(\(response.statusCode))======")
                    observer(.success(.failure(ErrorType(statusCode: response.statusCode))))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(responseT.self, from: data)
                    observer(.success(.success(response)))
                } catch {
                    print("======data decode======")
                    print(error)
                    observer(.success(.failure(ErrorType(statusCode: 0))))
                }
            }.resume()
            
            return disposables
        }
    }
    
    private func setupRequest(_ request: APIRequest) -> URLRequest? {
        guard var urlComponents = URLComponents(string: request.endpoint) else { return nil }
        
        urlComponents.queryItems = request.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 5)
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}
