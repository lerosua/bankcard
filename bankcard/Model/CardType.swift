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
    case ABC      //中国农业银行
    case BOC      //中国银行
    case CCB      //中国建设银行
    case CEB      //中国光大银行
    case CGB      //广发银行
    case CITIC    //中信银行
    case CMBC     //中国民生银行
    case CMB      //招商银行
    case CIB      //兴业银行
    case HXB      //华夏银行
    case ICBC     //中国工商银行
    case PSBC     //中国邮政储蓄银行
    case PAB      //平安银行
    case SPDB     //上海浦东发展银行
    case BOS      //上海银行
    case HFB      //恒丰银行
    case JSB      //江苏银行
}
