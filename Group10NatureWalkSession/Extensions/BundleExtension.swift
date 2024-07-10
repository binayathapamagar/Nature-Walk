//
//  BundleExtension.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-03.
//

import Foundation


extension Bundle {
    
    ///Decodes the JSON file that is stored locally in the Bundle and returns the decoded data.
    func decode<T: Codable>(_ file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate the \(file) in the Bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load the \(file) from the Bundle.")
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode the \(file) in the Bundle.")
        }
        return decodedData
        
    }
    
}
