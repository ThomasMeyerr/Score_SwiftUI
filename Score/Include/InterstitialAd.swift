//
//  InterstitialAd.swift
//  Score
//
//  Created by Thomas Meyer on 13/11/2024.
//

import GoogleMobileAds
import SwiftUI


class InterstitialAd: NSObject, GADFullScreenContentDelegate, Observable {
    private var interstitial: GADInterstitialAd?
    @Published var adLoaded = false
    
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-7069513903308677~7960370828", request: request) { ad, error in
            if let error = error {
                print("Error while loading: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.adLoaded = true
        }
    }
    
    func showAd(from rootViewController: UIViewController) {
        if let ad = self.interstitial {
            ad.present(fromRootViewController: rootViewController)
        } else {
            print("Ad is not ready yet")
        }
    }
}
