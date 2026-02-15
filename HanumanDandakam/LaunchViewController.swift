//
//  Untitled.swift
//  HanumanDandakam
//
//  Created by Kamesh Middi on 30/11/25.
//


import UIKit
import AVFoundation
import GoogleMobileAds

class LaunchViewController: UIViewController {
    
    var interstitial: AdManagerInterstitialAd!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.setBackground()
        }){_ in
            self.goToAd()
        }
    }
    
    func goToHome() {
        let groupsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(groupsVC ?? UIViewController(), animated: true)
    }
    
    func goToAd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadAds()
        }
    }
    
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        let blue = UIColor(red: 73/255.0,
                           green: 157/255.0,
                           blue: 232/255.0,
                           alpha: 1.0).cgColor
        let orange = UIColor(red: 232/255.0,
                             green: 73/255.0,
                             blue: 232/255.0,
                             alpha: 1.0).cgColor
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
        gradientLayer.colors = [orange, blue]
        gradientLayer.locations = [0.2, 0.8]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func loadAds() {
        Task {
            await loadInterstitial()
        }
        
        func loadInterstitial() async {
          do {
            interstitial = try await AdManagerInterstitialAd.load(
              with: "ca-app-pub-4653214442142853/3370815727", request: AdManagerRequest())
            interstitial?.fullScreenContentDelegate = self
              interstitial.present(from: self)
          } catch {
              goToHome()
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
          }
        }
    }
}

extension LaunchViewController: FullScreenContentDelegate {
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("\(#function) called with error: \(error.localizedDescription)")
      // Clear the interstitial ad.
      interstitial = nil
        goToHome()
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
      // Clear the interstitial ad.
      interstitial = nil
        goToHome()
    }
}
