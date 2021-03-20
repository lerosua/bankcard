//
//  CardType.swift
//  bankcard
//
//  Created by rosua le on 2021/3/20.
//

import Foundation

//卡类型
enum CardType:Int {
    case Bank = 0  //银行卡
    case Credit    //信用卡
    case ID       //ID卡，身份证照片
    case Birth    //生日卡，记录生日
}

//银行卡类型
enum BankType:Int {
    case Other = 0
    case ICBC     //工商银行
    case ABC      //农业银行
    case BOC      //中国银行
    case CCB      //中国建设银行
    case CMB      //招商银行
}
