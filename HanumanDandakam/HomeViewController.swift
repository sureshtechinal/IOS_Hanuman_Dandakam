//
//  Untitled.swift
//  HanumanDandakam
//
//  Created by Kamesh Middi on 30/11/25.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {

    let homeTiles = HomeTile.allCases
    @IBOutlet var collectionView: UICollectionView!
    var gradientLayer: CAGradientLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hanuman Dandakam"
        setBackground()
        loadBanner()
        // Do any additional setup after loading the view.
    }
    
    func setBackground() {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
        }
        
        let green = UIColor(red: 138/255.0,
                           green: 203/255.0,
                           blue: 148/255.0,
                           alpha: 1.0).cgColor
        let yellow = UIColor(red: 255/255.0,
                             green: 189/255.0,
                             blue: 0/255.0,
                             alpha: 1.0).cgColor
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
        gradientLayer?.colors = [yellow, green]
        gradientLayer?.locations = [0.2, 0.8]
        gradientLayer?.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer!, at: 0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeTiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as! TileCell
        let tileName = homeTiles[indexPath.row].rawValue
        cell.icon.image = UIImage(named: tileName)
        cell.title.text = tileName.capitalized
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch homeTiles[indexPath.row] {
        case .walls:
            loadDetails()
        case .story:
            loadDetails()
        case .songs:
            let audioVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AudioViewController") as? AudioViewController
            self.navigationController?.pushViewController(audioVC!, animated: true)
            break
        case .temples:
            loadDetails()
        }
        
        func loadDetails() {
            let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            detailsVC?.title = homeTiles[indexPath.row].rawValue.capitalized
            self.navigationController?.pushViewController(detailsVC ?? UIViewController(), animated: true)
        }
    }
}

extension HomeViewController: BannerViewDelegate {
    
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


enum HomeTile: String, CaseIterable {
    case walls
    case story
    case songs
    case temples
}


class TileCell: UICollectionViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UILabel!
}
