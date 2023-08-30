//
//  PassCore.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import Foundation

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

class CardPassObj {
    var type:Int
    var name:String
    var cardNumber:String
    var password:String
    var remark:String
 
    
    init(type:Int,name:String,cardNumber:String,password:String,remark:String){
        self.type = type
        self.name = name
        self.cardNumber = cardNumber
        self.password = password
        self.remark = remark
    }
    
    func save(){
        
    }
}

