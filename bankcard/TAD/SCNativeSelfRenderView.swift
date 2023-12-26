//
//  SCNativeSelfRenderView.swift
//  GMGossip
//
//  Created by rosua le on 2023/12/24.
//

import UIKit
import AnyThinkNative

class SCNativeSelfRenderView: UIView {

    var nativeAdOffer: ATNativeAdOffer
    var mediaImageView: UIImageView?

    var advertiserLabel: UILabel!
    var textLabel: UILabel!
    var titleLabel: UILabel!
    var ctaLabel: UILabel!
    var ratingLabel: UILabel!
    var iconImageView: UIImageView!
    var mainImageView: UIImageView!
    var logoImageView: UIImageView!
    var dislikeButton: UIButton!
    var mediaContainerView: UIView?
    var mediaView: UIView?

    // Only for Yandex native
    var domainLabel: UILabel?
    var warningLabel: UILabel?

    init(offer: ATNativeAdOffer) {
        nativeAdOffer = offer
        super.init(frame: CGRect.zero)
        addView()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {
        advertiserLabel = UILabel()
        advertiserLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        advertiserLabel.textColor = UIColor.black
        advertiserLabel.textAlignment = .left
        advertiserLabel.isUserInteractionEnabled = true
        advertiserLabel.layer.masksToBounds = true
        advertiserLabel.layer.cornerRadius = 10
        addSubview(advertiserLabel)

        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.isUserInteractionEnabled = true
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        addSubview(titleLabel)

        textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        textLabel.textColor = UIColor.black
        textLabel.isUserInteractionEnabled = true
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = 10
        addSubview(textLabel)

        ctaLabel = UILabel()
        ctaLabel.font = UIFont.systemFont(ofSize: 15.0)
        ctaLabel.textColor = UIColor.black
        ctaLabel.isUserInteractionEnabled = true
        ctaLabel.layer.masksToBounds = true
        ctaLabel.layer.cornerRadius = 10
        addSubview(ctaLabel)

        ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 15.0)
        ratingLabel.textColor = UIColor.black
        ratingLabel.isUserInteractionEnabled = true
        ratingLabel.layer.masksToBounds = true
        ratingLabel.layer.cornerRadius = 10
        addSubview(ratingLabel)

        domainLabel = UILabel()
        domainLabel!.font = UIFont.systemFont(ofSize: 15.0)
        domainLabel!.textColor = UIColor.black
        domainLabel!.isUserInteractionEnabled = true
        domainLabel!.layer.masksToBounds = true
        domainLabel!.layer.cornerRadius = 10
        addSubview(domainLabel!)

        warningLabel = UILabel()
        warningLabel!.font = UIFont.systemFont(ofSize: 15.0)
        warningLabel!.textColor = UIColor.black
        warningLabel!.isUserInteractionEnabled = true
        warningLabel!.layer.masksToBounds = true
        warningLabel!.layer.cornerRadius = 10
        addSubview(warningLabel!)

        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 4.0
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 10
        addSubview(iconImageView)

        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.isUserInteractionEnabled = true
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.cornerRadius = 10
        addSubview(mainImageView)

        mediaImageView = UIImageView()
        mediaImageView?.contentMode = .scaleAspectFit
        mediaImageView?.isUserInteractionEnabled = true
        // 针对gromore兼容三图容器
        if nativeAdOffer.networkFirmID == 46 {
            mediaContainerView = UIView()
            addSubview(mediaContainerView!)

//            mediaImageView = UIImageView()
//            mediaImageView?.contentMode = .scaleAspectFit
//            mediaImageView?.isUserInteractionEnabled = true
            mediaContainerView?.addSubview(mediaImageView!)
        }

        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.isUserInteractionEnabled = true
        logoImageView.layer.masksToBounds = true
        logoImageView.layer.cornerRadius = 10
        addSubview(logoImageView)

        let closeImg = UIImage(named: "icon_webview_close", in: Bundle(path: Bundle.main.path(forResource: "AnyThinkSDK", ofType: "bundle")!), compatibleWith: nil)
        dislikeButton = UIButton(type: .custom)
        dislikeButton.layer.masksToBounds = true
        dislikeButton.layer.cornerRadius = 10
        dislikeButton.setImage(closeImg, for: .normal)
        addSubview(dislikeButton)
    }

    func setupUI() {
        iconImageView.image = nativeAdOffer.nativeAd.icon
           if iconImageView.image == nil, let iconUrl = nativeAdOffer.nativeAd.iconUrl, !iconUrl.isEmpty {
               fetchImageUsingNSURLSession(from: URL(string: iconUrl)!) { [weak self] image in
                   self?.iconImageView.image = image
               }
           }

           mainImageView.image = nativeAdOffer.nativeAd.mainImage
        if nativeAdOffer.nativeAd.mainImage != nil {
            mediaImageView!.image = nativeAdOffer.nativeAd.mainImage
        }
           if mainImageView.image == nil, let imageUrl = nativeAdOffer.nativeAd.imageUrl, !imageUrl.isEmpty {
               fetchImageUsingNSURLSession(from: URL(string: imageUrl)!) { [weak self] image in
                   self?.mainImageView.image = image
               }
               fetchImageUsingNSURLSession(from: URL(string: imageUrl)!) { [weak self] image in
                   self?.mediaImageView!.image = image
               }
           }

           if let logoUrl = nativeAdOffer.nativeAd.logoUrl, !logoUrl.isEmpty {
               fetchImageUsingNSURLSession(from: URL(string: logoUrl)!) { [weak self] image in
                   self?.logoImageView.image = image
               }
           }

           advertiserLabel.text = nativeAdOffer.nativeAd.advertiser
           titleLabel.text = nativeAdOffer.nativeAd.title
           textLabel.text = nativeAdOffer.nativeAd.mainText
           ctaLabel.text = nativeAdOffer.nativeAd.ctaText
           ratingLabel.text = "\(nativeAdOffer.nativeAd.rating ?? 0)"
           domainLabel?.text = nativeAdOffer.nativeAd.domain
           warningLabel?.text = nativeAdOffer.nativeAd.warning
    }

    func fetchImageUsingNSURLSession(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard let superview = superview else { return }

        self.iconImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
           self.titleLabel.frame = CGRect(x: 55, y: 0, width: superview.frame.size.width - 60, height: self.titleLabel.font.lineHeight)
           self.textLabel.frame = CGRect(x: 55, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5, width: superview.frame.size.width - 60, height: self.textLabel.font.lineHeight)

           self.mainImageView.frame = CGRect(x: 0, y: self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 5, width: superview.frame.size.width, height: superview.frame.size.height - (self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 5))
 
        
        let originY = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 5
        let height = superview.frame.size.height - originY
         self.mediaView!.frame = CGRect(x: 0, y: originY, width: superview.frame.size.width, height: height)

           self.logoImageView.frame = CGRect(x: 0, y: superview.frame.size.height - 35, width: 30, height: 30)
       
    }
}

