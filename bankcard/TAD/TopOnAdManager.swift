//
//  TopOnMediation.swift
//  GMGossip
//
//  Created by rosua le on 2023/12/13.
//


import Foundation
import AnyThinkSplash
import AnyThinkRewardedVideo
import AnyThinkNative

enum SCMediationType {
    case rewardedVideoAd
    case splash
    case native
}

class TopOnAdManager:NSObject,ATAdLoadingDelegate,ATRewardedVideoDelegate,ATSplashDelegate{
    func didFailToLoadAD(withPlacementID placementID: String!, error: Error!) {
        print("get \(String(describing: error))")
    }
    //单例
    public static var shared:TopOnAdManager = {
        let instance : TopOnAdManager = TopOnAdManager()
        return instance;
    }()
    
    var splashPlacementIds:[String] = [TapPlacementId]
    var rewardVideoPlacementIds = [TapVideoId]
    
        func register(withAppId appId: String, appKey: String) {
            try? ATAPI.sharedInstance().start(withAppID: appId, appKey: appKey)
            ATAPI.setLogEnabled(true)
            ATAPI.integrationChecking()
        }

        func load(withType type: SCMediationType, placementId: String) {
            internalLoad(withType: type, placementId: placementId)
        }

        private func internalLoad(withType type: SCMediationType, placementId: String) {
            switch type {
            case .rewardedVideoAd:
                loadRewardedVideo(withPlacementId: placementId)
            case .splash:
                loadSplash(withPlacementId: placementId)
            case .native:
                loadNative(withPlacementId: placementId)
            }
        }

        private func loadSplash(withPlacementId placementId: String) {
            ATAdManager.shared().loadAD(withPlacementID: placementId, extra: [:], delegate: self)
        }

        private func loadRewardedVideo(withPlacementId placementId: String) {
            ATAdManager.shared().loadAD(withPlacementID: placementId, extra: [:], delegate: self)
        }
        private func loadNative(withPlacementId placementId: String){
            ATAdManager.shared().loadAD(withPlacementID: placementId, extra: [:], delegate: self)
        }
    
        // ATAdLoadingDelegate methods
        func didFinishLoadingAD(withPlacementID placementID: String) {
//            hideLoading(withView: nil)
            var keyWindow: UIWindow?
            guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                return
            }
            keyWindow = windowScene.windows.first
            
            keyWindow?.makeKeyAndVisible()
            
            if ATAdManager.shared().adReady(forPlacementID: placementID) {
                if splashPlacementIds.contains(placementID) {
//                    splashDelegate?.ad(nil, didLoadComplete: true, type: .splash)
                    ATAdManager.shared().showSplash(withPlacementID: placementID, scene: "", window: keyWindow!, delegate: self)
                } else if rewardVideoPlacementIds.contains(placementID) {
                    ATAdManager.shared().showRewardedVideo(withPlacementID: placementID, in: (keyWindow?.rootViewController)!, delegate: self)
                }else if placementID == TapNavtiveADId {
                    print("success load native ad \(placementID)")
                    
//                    let naviveItem = SCNativeItem(placementId: TapNavtiveADId)
//                    naviveItem.showNative(with: keyWindow!)
                    
                }
            }
        }

        func didFail(toLoadADWithPlacementID placementID: String, error: Error) {
            print("faile load ad :\(error)")
        }

        // ATRewardedVideoDelegate methods
        func rewardedVideoDidStartPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        }

        func rewardedVideoDidEndPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        }

        func rewardedVideoDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.rewardVideoAdInfo.setShowed()
        }

        func rewardedVideoDidClose(forPlacementID placementID: String, rewarded: Bool, extra: [AnyHashable : Any]) {
//            rewardVideoDelegate?.ad(nil, didShowComplete: rewarded, type: .rewardedVideoAd)
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.rewardVideoAdInfo.setShowed()

            if let idfv = UserDefaults.standard.object(forKey: "idfv") as? String {
//                MobClick.event("walking_reward_video_watch_close_count", attributes: ["idfv": idfv])
            }
        }

        func rewardedVideoDidRewardSuccess(forPlacemenID placementID: String, extra: [AnyHashable : Any]) {
        }

    func rewardedVideoDidFailToPlay(forPlacementID placementID: String, error: Error, extra: [AnyHashable : Any]) {
//            if error == nil {
//                if let idfv = UserDefaults.standard.object(forKey: "idfv") as? String {
//                    MobClick.event("walking_reward_video_watch_finish_count", attributes: ["idfv": idfv])
//                }
//            }
        }

        func rewardedVideoDidDeepLinkOrJump(forPlacementID placementID: String, extra: [AnyHashable : Any], result success: Bool) {
        }

        // ATSplashDelegate methods
        func splashDidShow(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        }

        func splashDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        }

        func splashDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.splashAdInfo.setShowed()
        }

        func splashDidFail(toShowForPlacementID placementID: String, error: Error) {
//            hideLoading(withView: nil)
//            splashDelegate?.ad(nil, didLoadComplete: false, type: .splash)
        }
    }

extension TopOnAdManager:ATNativeADDelegate{
    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("didShowNativeAd")
     }
    
    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("didClickNativeAd")

    }
}

class TopOnNativeAD:NSObject,ATNativeADDelegate{
    //单例
    public static var shared:TopOnNativeAD = {
        let instance : TopOnNativeAD = TopOnNativeAD()
        return instance;
    }()
    
    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("Native-didShowNativeAd")

    }
    
    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("Native-didClickNativeAd")

    }
    
    func didFinishLoadingAD(withPlacementID placementID: String!) {
        print("Native-didFinishLoadingAD \(String(describing: placementID)) ")

    }
    
    func didFailToLoadAD(withPlacementID placementID: String!, error: Error!) {
        print("Native-didFailToLoadAD \(String(describing: error))")

    }
    func load(placementId: String) {
        
        ATAdManager.shared().loadAD(withPlacementID: placementId, extra: [kATNativeAdSizeToFitKey:true,kATExtraInfoNativeAdSizeKey:CGSize(width: kScreenWidth, height: 200)], delegate: self)
    }
    
}
