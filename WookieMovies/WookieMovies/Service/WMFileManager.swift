//
//  WMFileManager.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import Foundation

enum WMImageType {
    case backdrop
    case poster
}

struct WMFileManager {
    var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func createImageDirs() {
        var path = documentsDirectory.appendingPathComponent("backdrop").path
        var exist = FileManager.default.fileExists(atPath: path)
        if !exist {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create directory failed: \(error)")
            }
        }
        path = documentsDirectory.appendingPathComponent("poster").path
        exist = FileManager.default.fileExists(atPath: path)
        if !exist {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create directory failed: \(error)")
            }
        }
    }

    func getPathForImage(id: String, type: WMImageType) -> URL {
        var pathComponent = ""
        switch type {
        case .backdrop:
            pathComponent = "backdrop/\(id).jpg"
        case .poster:
            pathComponent = "poster/\(id).jpg"
        }
        return documentsDirectory.appendingPathComponent(pathComponent)
    }
    
    func checkIfFileExists(id: String, type: WMImageType) -> Bool {
        var pathComponent = ""
        switch type {
        case .backdrop:
            pathComponent = "backdrop/\(id).jpg"
        case .poster:
            pathComponent = "poster/\(id).jpg"
        }
        let fullPath = documentsDirectory.appendingPathComponent(pathComponent).path
        return FileManager.default.fileExists(atPath: fullPath)
    }
    
    func flushDocumentsDirectory() -> Bool {
        guard let paths = try? FileManager.default.contentsOfDirectory(at: self.documentsDirectory, includingPropertiesForKeys: nil) else { return false }
        
        for path in paths {
            try? FileManager.default.removeItem(at: path)
        }
        return true
    }
}
