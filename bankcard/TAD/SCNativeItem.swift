//
//  SCNativeItem.swift
//  GMGossip
//
//  Created by rosua le on 2023/12/24.
//

import UIKit
import AnyThinkNative
let nativeItemHeight:Double = 80

class SCNativeItem: NSObject, ATNativeADDelegate {
    func didFinishLoadingAD(withPlacementID placementID: String!) {
        print("didFinishLoadingAD \(String(describing: placementID))")
    }
    
    func didFailToLoadAD(withPlacementID placementID: String!, error: Error!) {
        print("didFailToLoadAD \(String(describing: placementID)) with error:\(String(describing: error))")

    }
    
    var placementId: String

    init(placementId: String) {
        self.placementId = placementId
        super.init()
    }

    func showNative(with superView: UIView)->CGSize {
        guard !placementId.isEmpty else {
            print("placementId must be not nil")
            assertionFailure()
            return CGSizeZero
        }

        if ATAdManager.shared().nativeAdReady(forPlacementID: placementId) {
            let offer = ATAdManager.shared().getNativeAdOffer(withPlacementID: placementId)

            let config = ATNativeADConfiguration()
            config.adFrame = CGRect(x: 0, y: 0, width: superView.frame.size.width, height: nativeItemHeight)
            config.rootViewController = UIApplication.shared.keyWindow?.rootViewController
            config.sizeToFit = true
            config.delegate = self

            let selfRenderView = SCNativeSelfRenderView(offer: offer)
            var clickableViewArray: [UIView] = [selfRenderView.iconImageView,
                                               selfRenderView.titleLabel,
                                               selfRenderView.textLabel,
                                               selfRenderView.ctaLabel,
                                               selfRenderView.mainImageView]

            let nativeADView = ATNativeADView(configuration: config, currentOffer: offer, placementID: placementId)
            if !offer.nativeAd.isExpressAd {
                let mediaView = nativeADView.getMediaView()
                if mediaView != nil {
                     clickableViewArray.append(mediaView)
                    selfRenderView.mediaView = mediaView
                    selfRenderView.addSubview(mediaView)
                    selfRenderView.bringSubviewToFront(selfRenderView.logoImageView)
                }

                nativeADView.registerClickableViewArray(clickableViewArray)

                let info = ATNativePrepareInfo.load { prepareInfo in
                    prepareInfo.textLabel = selfRenderView.textLabel
                    prepareInfo.advertiserLabel = selfRenderView.advertiserLabel
                    prepareInfo.titleLabel = selfRenderView.titleLabel
                    prepareInfo.ratingLabel = selfRenderView.ratingLabel
                    prepareInfo.iconImageView = selfRenderView.iconImageView
                    prepareInfo.mainImageView = selfRenderView.mainImageView
                    prepareInfo.logoImageView = selfRenderView.logoImageView
                    prepareInfo.dislikeButton = selfRenderView.dislikeButton
                    prepareInfo.ctaLabel = selfRenderView.ctaLabel
                    prepareInfo.domainLabel = selfRenderView.domainLabel ?? UILabel()
                    prepareInfo.warningLabel = selfRenderView.warningLabel ?? UILabel()
                    prepareInfo.mediaView = selfRenderView.mediaView ?? UIView()
                    prepareInfo.mediaContainerView = selfRenderView.mediaContainerView ?? UIView()
                }

                nativeADView.prepare(with: info)
                nativeADView.backgroundColor = UIColor.white
            } else {
                var adViewWidth = offer.nativeAd.nativeExpressAdViewWidth
                var adViewHeight = offer.nativeAd.nativeExpressAdViewHeight

                if adViewWidth == 0 {
                    adViewWidth = superView.frame.size.width
                }

                if adViewHeight == 0 {
                    adViewHeight = superView.frame.size.height
                }

                let adFrame = CGRect(x: 0, y: 0, width: adViewWidth, height: adViewHeight)
                config.adFrame = adFrame
            }

            offer.renderer(with: config, selfRenderView: selfRenderView, nativeADView: nativeADView)
            superView.addSubview(nativeADView)
            return CGSize(width: config.adFrame.width, height: config.adFrame.height)
        }else{
            print("not get ready")
            return CGSizeZero
        }
    }

    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        // Native ads displayed successfully
    }

    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        // Native ad click
    }
}
