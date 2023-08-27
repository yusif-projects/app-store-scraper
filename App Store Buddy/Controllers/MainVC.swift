//
//  MainVC.swift
//  App Store Buddy
//
//  Created by Yusif Aliyev on 27.08.23.
//

import UIKit
import AlamofireImage

class MainVC: PrototypeVC {
    
    @IBOutlet weak private var appIconView: UIImageView!
    @IBOutlet weak private var appIconShadowView: UIView!
    @IBOutlet weak private var appIconShadowViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak private var labelStackView: UIStackView!
    
    @IBOutlet weak private var appTitleLabel: UILabel!
    @IBOutlet weak private var appTaglineLabel: UILabel!
    @IBOutlet weak private var appPriceLabel: UILabel!
    @IBOutlet weak private var appRatingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconWidth = view.frame.size.width * 0.75
        let iconCornerRadius = iconWidth / 5
        let shadowViewWidth = iconWidth - iconCornerRadius
        
        appIconShadowViewWidth.constant = shadowViewWidth
        
        appIconView.layer.cornerRadius = iconCornerRadius
        
        appIconShadowView.layer.shadowColor = UIColor.black.cgColor
        appIconShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        appIconShadowView.layer.shadowOpacity = 1 / 2
        appIconShadowView.layer.shadowRadius = 32
        
        resetUI()
        
        AppStoreScraper.scrape(appId: "id951615851") { [weak self] appInfo in
            guard let self = self,
                  let title = appInfo.title,
                  let tagline = appInfo.tagline,
                  let price = appInfo.price,
                  let rating = appInfo.rating,
                  let image = appInfo.image,
                  let imageURL = URL(string: "\(image)") else { return }
            
            let animationDuration: TimeInterval = 1 / 4
            
            self.appIconView.af.setImage(withURL: imageURL, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: .global(qos: .background), imageTransition: .crossDissolve(animationDuration), runImageTransitionIfCached: false) { img in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.appTitleLabel.text = title
                    self.appTaglineLabel.text = tagline
                    self.appPriceLabel.text = price
                    self.appRatingLabel.text = rating.replacingOccurrences(of: " • ", with: " Stars • ")
                    
                    UIView.animate(withDuration: animationDuration, delay: animationDuration, options: .curveLinear, animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.labelStackView.alpha = 1
                        self.appIconShadowView.alpha = 1
                    }, completion: nil)

                }
            }
        }
    }
    
    private func resetUI() {
        appTitleLabel.text = " "
        appTaglineLabel.text = " "
        appPriceLabel.text = " "
        appRatingLabel.text = " "
        
        appIconShadowView.alpha = 0
        
        labelStackView.alpha = 0
    }
    
}
