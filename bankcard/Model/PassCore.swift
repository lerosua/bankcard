//
//  PassCore.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import Foundation
import KeychainSwift

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
let CardListKey :String = "BankCardListKey_V1"
class CardPassObj:Codable {
    var type:Int
    var name:String
    var cardNumber:String
    var password:String
    var remark:String
    var icon:String = ""
    
    
    init(type:Int,name:String,cardNumber:String,password:String,remark:String){
        self.type = type
        self.name = name
        self.cardNumber = cardNumber
        self.password = password
        self.remark = remark
    }
    
    func copywith(item:CardPassObj){
        self.name = item.name
        self.cardNumber = item.cardNumber
        self.remark = item.remark
        self.password = item.password
        self.type = item.type
        self.icon = item.icon
    }
    
    
    
    //保存进keychain里
   static func SaveCardPassList(dataList:[CardPassObj]){
        let keychain = KeychainSwift()
        do{
            let data = try JSONEncoder().encode(dataList)
            keychain.set(data,forKey: CardListKey)
        }catch{
            print(error)
        }
    }
    static func GetCardPassList()->[CardPassObj]{
        let keychain = KeychainSwift()
        guard let data = keychain.getData(CardListKey) else {return []}
        do {
            return try JSONDecoder().decode([CardPassObj].self, from: data)
        }catch{
            print(error)
        }
        return []
    }
}
