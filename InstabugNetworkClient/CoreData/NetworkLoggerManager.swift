//
//  NetworkLoggerManager.swift
//  InstabugNetworkClient
//
//  Created by Esraa Gamal on 30/04/2022.
//

import Foundation
import CoreData

 class NetworkLoggerManager {
    
    let recordsLimit: Int
    let payloadSizeLimit: Size
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext,
         logsLimit: Int, payloadSizeLimit: Size) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        self.recordsLimit = logsLimit
        self.payloadSizeLimit = payloadSizeLimit
    }
    
    func saveRecord(url: String, method: String, payload: String?, statusCode: Int64?, error: Error?, responseBody: String?) {
        
        if loadAllRecords().count >= recordsLimit {
            deleteFirstRecord()
        }
        
        let request = Request(context: backgroundContext)
        request.url = url
        request.method = method
        request.payload = getPayloadWithRespectTo(size: payloadSizeLimit, payload)
        
        let response = Response(context: backgroundContext)
        response.statusCode = statusCode ?? 0
        response.payload = getPayloadWithRespectTo(size: payloadSizeLimit, responseBody)
        
        if let responseError = error {
            let error = ResponseError(context: backgroundContext)
            error.code = responseError.errorCode ?? 0
            error.domain = responseError.errorDomain
            response.error = error
        }
        
        let record = Record(context: backgroundContext)
        record.request = request
        record.response = response
        record.createdAt = Date()
        
        writeToDataBase()
    }
    
    func writeToDataBase() {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
                print("There Was an Error Saving Record: \(error)")
            }
        }
    }
    
    func loadAllRecords() -> [Record] {
        let fetchRequest : NSFetchRequest<Record> = Record.fetchRequest()
        var records : [Record] = []
        
        mainContext.performAndWait {
            do {
                records = try mainContext.fetch(fetchRequest)
            } catch {
                print("There Was an Error fetching Record: \(error)")
            }
        }
        
        return records
    }
    
    func deleteAllRecords() {
        let results = getRecordsFromBackGroundContext()
        for result in results {
            backgroundContext.delete(result)
            do {
                try backgroundContext.save()
            } catch {
                print("There Was an Error Deleting Records: \(error)")
            }
        }
    }
    
    func deleteFirstRecord() {
        if let result = getRecordsFromBackGroundContext().min(by: { $0.createdAt ?? Date() < $1.createdAt ?? Date()}) {
            backgroundContext.delete(result)
            do {
                try backgroundContext.save()
            } catch {
                print("There Was an Error Deleting Record: \(error)")
            }
        }
    }
    
    //MARK: Helpers
    
    func getPayloadWithRespectTo(size: Size, _ text: String?) -> String? {
        if let text = text, !Validator.validateLengthOf(text: text, withMaximum: size){
            return "(payload too large)"
        }
        return text
    }
    
    func getRecordsFromBackGroundContext() -> [Record] {
        let fetchRequest : NSFetchRequest<Record> = Record.fetchRequest()
        var records : [Record] = []
        
        backgroundContext.performAndWait {
            do {
                records = try backgroundContext.fetch(fetchRequest)
            } catch {
                print("There Was an Error fetching Record: \(error)")
            }
        }
        
        return records
    }
 }
