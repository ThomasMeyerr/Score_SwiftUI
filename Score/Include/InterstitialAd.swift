//
//  InterstitialAd.swift
//  Score
//
//  Created by Thomas Meyer on 01/12/2024.
//

import Foundation
import GoogleMobileAds


//class InterstitialAd: NSObject, GADFullScreenContentDelegate {
//    private var interstitialAd: GADInterstitialAd?
//    
//    func loadAd() async {
//        do {
//            interstitialAd = try await GADInterstitialAd.load(withAdUnitID: interstitialID, request: GADRequest())
//            interstitialAd?.fullScreenContentDelegate = self
//        } catch {
//            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//        }
//    }
//    
//    func showAd() {
//        guard let interstitialAd = interstitialAd else {
//            return print("Ad wasn't ready")
//        }
//        
//        interstitialAd.present(fromRootViewController: nil)
//    }
//    
//    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
//      print("\(#function) called")
//    }
//
//    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
//      print("\(#function) called")
//    }
//
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//      print("\(#function) called")
//    }
//
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//      print("\(#function) called")
//    }
//
//    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//      print("\(#function) called")
//    }
//
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//      print("\(#function) called")
//      // Clear the interstitial ad.
//      interstitialAd = nil
//    }
//}
