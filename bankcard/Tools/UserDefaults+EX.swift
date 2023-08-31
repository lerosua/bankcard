//
//  UserDefaults+EX.swift
//  bankcard
//
//  Created by rosua le on 2023/8/31.
//

import Foundation

extension UserDefaults {
    //保存类数组
    func set<T:Encodable>(classArray object:[T],key:String){
        do {
            let data = try JSONEncoder().encode(object)
            self.set(data,forKey: key)
        }catch{
            print(error)
        }
    }
    //读取类数组
    func classArray<T:Decodable>(forKey key:String)->[T]{
        guard let data = self.data(forKey: key) else {return []}
        do {
            return try JSONDecoder().decode([T].self, from: data)
        }catch{
            print(error)
        }
        return []
    }
}
