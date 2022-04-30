//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
    
    public static var shared = NetworkClient()
    let logger : NetworkLoggerManager
    
    init() {
        let coreDataManager = CoreDataManager.shared
        logger = NetworkLoggerManager(mainContext: coreDataManager.mainContext, backgroundContext: coreDataManager.backgroundContext, logsLimit: 1000, payloadSizeLimit: .MB)
        logger.deleteAllRecords()
    }
    
    // MARK: Network requests
    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }
    
    public func post(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "POSt", payload: payload, completionHandler: completionHandler)
    }
    
    public func put(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }
    
    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }
    
    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.logger.saveRecord(url: url.absoluteString, method: method, payload: payload?.base64EncodedString(), statusCode: Int64(httpResponse.statusCode), error: error, responseBody: httpResponse.description)                
            } else {
                self.logger.saveRecord(url: url.absoluteString, method: method, payload: payload?.base64EncodedString(), statusCode: nil, error: error, responseBody: nil)
                if let errorDescription = error?.localizedDescription {
                    print(errorDescription)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }.resume()
    }
    
    // MARK: Network recording
    
    public func allNetworkRequests() -> [Record] {
        return logger.loadAllRecords()
    }
}
