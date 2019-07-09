//
//  CacheManager.swift
//  Repost
//
//  Created by David Adel on 7/1/19.
//  Copyright © 2019 MGPluses. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {
    
    static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    
    private lazy var mainDirectoryUrl: URL = {
        
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        
        
        let file = directoryFor(stringUrl: stringUrl)
        
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }
        
        DispatchQueue.global().async {
            
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                
                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError(domain: "Video Download", code: -200, userInfo: ["description": "Can't download video"])))
                    
                }
            }
        }
    }
    
    func getFileWith(stringUrl: String, postId:String, completionHandler: @escaping (Result<URL>) -> Void ) {
        
        
        let file = directoryFor(stringUrl: stringUrl)
        
        updatePost(postId: postId, videoPath: file.path)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }
        
        DispatchQueue.global().async {
            
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                
                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError(domain: "Video Download", code: -200, userInfo: ["description": "Can't download video"])))
                    
                }
            }
        }
    }
    
    func deleteFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        
        let file = directoryFor(stringUrl: stringUrl)
        
        if fileManager.fileExists(atPath: file.path){
            do{
                try fileManager.removeItem(at: file)
                completionHandler(Result.success(file))
            }catch{
                completionHandler(Result.failure(NSError(domain: "Video Delete", code: -200, userInfo: ["description": "Can't delete video"])))
            }
        }
    }
    
    func deleteMultipleFilesWith(childsURLs: [URL], completionHandler: @escaping (Result<URL>) -> Void ) {
        
        for stringUrl in childsURLs{
            let file = directoryFor(stringUrl: stringUrl.absoluteString)
            
            if fileManager.fileExists(atPath: file.path){
                do{
                    try fileManager.removeItem(at: file)
                    completionHandler(Result.success(file))
                }catch{
                    completionHandler(Result.failure(NSError(domain: "Video Delete", code: -200, userInfo: ["description": "Can't delete video"])))
                }
            }
        }
    }
    
    private func directoryFor(stringUrl: String) -> URL {
        
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        
        return file
    }
    
    func clearCache(_ url:URL) {
        
        do {
            
            let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
            
            print("before  \(contents)")
            
            let urls = contents.map { URL(string:"\(url.appendingPathComponent("\($0)"))")! }
            
            urls.forEach {  try? FileManager.default.removeItem(at: $0) }
            
            let con = try FileManager.default.contentsOfDirectory(atPath: url.path)
            
            print("after \(con)")
            
        }
        catch {
            
            print(error)
            
        }
        
    }
}
