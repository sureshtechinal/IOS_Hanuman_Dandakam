//
//  AudioViewController.swift
//  HanumanDandakam
//
//  Created by Kamesh Middi on 30/11/25.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class AudioViewController: UIViewController {
    var gradientLayer: CAGradientLayer?
    var selectedType: String = ""
    @IBOutlet var collectionView: UICollectionView!
    var soundPlayer: AVAudioPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Hanuman Songs"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        loadBanner()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"),
                                                            style: .plain, target: self,
                                                            action: #selector(playPauseSound))
    }
    
    func setBackground() {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
        }
        
        let blue = UIColor(red: 0/255.0,
                           green: 0/255.0,
                           blue: 247/255.0,
                           alpha: 1.0).cgColor
        let black = UIColor.black.cgColor
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
        gradientLayer?.colors = [black, blue]
        gradientLayer?.locations = [0.2, 0.8]
        gradientLayer?.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer!, at: 0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func playSound(index: Int) {
        if let url = Bundle.main.url(forResource: AudioTiles.allCases[index].rawValue, withExtension: "mp3") {
            do {
                soundPlayer = try! AVAudioPlayer(contentsOf: url)
                playPauseSound()
                
                let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
                detailsVC?.title = AudioTiles.allCases[index].rawValue
                self.navigationController?.pushViewController(detailsVC ?? UIViewController(), animated: true)
            }
        }
    }
    
    @objc func playPauseSound() {
        if soundPlayer != nil {
            if soundPlayer.isPlaying {
                soundPlayer.pause()
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"),
                                                                    style: .plain, target: self,
                                                                    action: #selector(playPauseSound))
            } else {
                soundPlayer.play()
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pause.fill"),
                                                                    style: .plain, target: self,
                                                                    action: #selector(playPauseSound))
            }
        }
    }
    
    func saveAudioFileToDocuments(index: Int) {
        let filename = AudioTiles.allCases[index].rawValue
        let fileExtension = "mp3"
        // 1. Locate the audio file in the bundle
        guard let bundleURL = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            showAlert(message: "Audio file not found")
            return
        }

        // 2. Determine the destination URL in local storage (Documents directory)
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlert(message:"Could not find file path")
            return
        }
        let destinationURL = documentsDirectory.appendingPathComponent("\(filename).\(fileExtension)")

        do {
            // 3. Read the audio file data from the bundle
            let audioData = try Data(contentsOf: bundleURL)

            // 4. Write the data to local storage
            try audioData.write(to: destinationURL)
            showAlert(message:"Audio file saved successfully")
        } catch {
            showAlert(message:"Error saving audio file")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension AudioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AudioTiles.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
        cell.icon.image = UIImage(named:AudioTiles.allCases[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsViewController") as? OptionsViewController
        optionsVC?.playSelectedSound = {
            self.playSound(index: indexPath.row)
        }
        optionsVC?.saveSelectedSound = {
            self.saveAudioFileToDocuments(index: indexPath.row)
        }
        self.navigationController?.pushViewController(optionsVC ?? UIViewController(), animated: true)
    }
}

extension AudioViewController: BannerViewDelegate {
    
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



class DetailsCell: UICollectionViewCell {
    @IBOutlet var gradientView: UIView!
    @IBOutlet var icon: UIImageView!
}

enum AudioTiles: String, CaseIterable {
    case BajarangChalisaOne = "Bajarang Chalisa one"
    case BajarangChalisaTwo = "Bajarang Chalisa two"
    case BajarangDandakam = "Bajarang Dandakam"
    case BajarangHanumanBaan = "Bajarang Hanuman Baan"
    case DevotionalAarti = "Devotional Aarti"
    case HeBajrangbaliHanuman = "He Bajrangbali Hanuman"
    case JaiJaiHanumanGusain = "Jai Jai Hanuman Gusain"
    case MangalmootiMarutiNandan = "Mangalmooti Maruti Nandan"
    case PawansutVintiBarambar = "Pawansut Vinti Barambar"
    case SankatMochan = "Sankat Mochan"
    case SankatmochanHanumanAshtak = "Sankat mochan Hanuman Ashtak"
    case ShreeHanumanJiKiAarti = "Shree Hanuman Ji Ki Aarti"
    case ShreeHanumanVandana = "Shree Hanuman Vandana"
    case ShreeHanunamStavan = "Shree Hanunam Stavan"
}
