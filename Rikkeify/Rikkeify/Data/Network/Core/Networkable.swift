//
//  Networkable.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Combine

public protocol Networkable {
    func sendRequest<T: Decodable>(urlStr: String) async throws -> T
    func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void)
}

extension Networkable {
    fileprivate func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        
        // Adding query parameters
        urlComponents.queryItems = endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Handling path parameters
        var path = endPoint.path
        for (key, value) in endPoint.pathParams ?? [:] {
            path = path.replacingOccurrences(of: "{\(key)}", with: value)
        }
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        
        return request
    }
}

public final class NetworkService: Networkable {
    public func sendRequest<T>(urlStr: String) async throws -> T where T : Decodable {
        guard let urlStr = urlStr as String?, let url = URL(string: urlStr) as URL?else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
//            throw NetworkError.unexpectedStatusCode
//        }
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        if 200...299 ~= response.statusCode {
            guard let data = data as Data? else {
                throw NetworkError.unknown
            }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decode
            }
            return decodedResponse
        } else if response.statusCode == 429 {
            throw NetworkError.expiredKey
        } else {
            throw NetworkError.unexpectedStatusCode
        }
    }
    
    public func sendRequest<T: Decodable>(endpoint: EndPoint,
                                          resultHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            return
        }
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            print("\n~~~~~~~~~~~~~~~~~~~Network Logs: StatusCode: \((response as? HTTPURLResponse)?.statusCode)")
//            print("\n~~~~~~~~~~~~~~~~~~~Network Logs: Error: \(error)")
            guard error == nil else {
                resultHandler(.failure(.invalidURL))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                resultHandler(.failure(.noResponse))
                return
            }

            if 200...299 ~= response.statusCode {
                guard let data = data else {
                    resultHandler(.failure(.unknown))
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    resultHandler(.success(decodedResponse))
//                    print("\n~~~~~~~~~~~~~~~~~~~Network Logs: Data: \(decodedResponse)")
                } catch {
                    print(error)
                    resultHandler(.failure(.decode))
                }
            } else if response.statusCode == 429 {
                resultHandler(.failure(.expiredKey))
            } else {
                    resultHandler(.failure(.unexpectedStatusCode))
            }
//            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
//                resultHandler(.failure(.decode))
//                return
//            }
//            resultHandler(.success(decodedResponse))
        }
        urlTask.resume()
    }
}
