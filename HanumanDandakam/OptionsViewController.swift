//
//  Untitled.swift
//  HanumanDandakam
//
//  Created by Kamesh Middi on 01/12/25.
//

import UIKit
import GoogleMobileAds

class OptionsViewController: UIViewController {
    
    var playSelectedSound: ()->() = {}
    
    var saveSelectedSound: ()->() = {}
    
    var gradientLayer: CAGradientLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .gray
        setBackground()
        loadBanner()
    }

    func setBackground() {
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
        }
        
        let blue = UIColor(red: 123/255.0,
                           green: 170/255.0,
                           blue: 249.0/255.0,
                           alpha: 1.0).cgColor
        let orange = UIColor(red: 255/255.0,
                             green: 129/255.0,
                             blue: 112/255.0,
                             alpha: 1.0).cgColor
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
        gradientLayer?.colors = [orange, blue]
        gradientLayer?.locations = [0.2, 0.8] // Start and end points of the gradient
        gradientLayer?.startPoint = CGPoint(x: 0.8, y: 1.0) // Top center
        gradientLayer?.endPoint = CGPoint(x: 0.2, y: 0.0)   // Bottom center (vertical gradient)
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    @IBAction func playSound() {
        self.navigationController?.popViewController(animated: true)
        playSelectedSound()
    }
    
    @IBAction func saveAudioFileToDocuments() {
        self.navigationController?.popViewController(animated: true)
        saveSelectedSound()
    }
}

extension OptionsViewController: BannerViewDelegate {
    
    func loadBanner() {
        var bannerView = BannerView()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        self.view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 150),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        bannerView.load(AdManagerRequest())
    }
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
      print(#function + ": " + error.localizedDescription)
    }

    func bannerViewDidRecordClick(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
      print(#function)
    }
}

