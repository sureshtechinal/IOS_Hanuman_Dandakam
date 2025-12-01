//
//  Untitled.swift
//  HanumanDandakam
//
//  Created by Kamesh Middi on 30/11/25.
//

import Foundation
import UIKit
import AVFoundation
import WebKit
import GoogleMobileAds

class DetailsViewController: UIViewController {
    var gradientLayer: CAGradientLayer?
    
    @IBOutlet var webView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBanner()
        switch title {
        case HomeTile.walls.rawValue.capitalized:
            self.title = "Hanuman Dandakam"
            webView.load(URLRequest(url: URL(string: "https://photos.app.goo.gl/eLW5Q3WtrFjqSdge6")!))
        case HomeTile.story.rawValue.capitalized:
            self.title = "Hanuman Dandakam"
            loadHtml(fileName: "history")
        case HomeTile.songs.rawValue.capitalized:
            break
        case HomeTile.temples.rawValue.capitalized:
            self.title = "Hanuman Dandakam"
            loadHtml(fileName: "temples")
        default:
            loadHtml(fileName: title!)
            break
        }
    }
    
    func loadHtml(fileName: String) {
        webView.loadFileURL(URL(fileURLWithPath: Bundle.main.path(forResource: fileName,
                                                                  ofType: "htm")!),
                            allowingReadAccessTo: URL(fileURLWithPath: Bundle.main.bundleURL.path))
    }
    
    func setBackground(randomBottomColor: CGColor) {
        let gradientLayer = CAGradientLayer()
        let top = UIColor(red: 117/255.0,
                          green: 250/255.0,
                          blue: 196/255.0,
                          alpha: 1.0).cgColor
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width+100, height: view.frame.height+100)
        gradientLayer.colors = [top, randomBottomColor as Any]
        gradientLayer.locations = [0.2, 0.8]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension DetailsViewController: BannerViewDelegate {
    
    func loadBanner() {
        let bannerView = BannerView()
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


