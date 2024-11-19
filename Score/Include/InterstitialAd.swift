//
//  InterstitialAd.swift
//  Score
//
//  Created by Thomas Meyer on 19/11/2024.
//

import Foundation
//import GoogleMobileAds
//
//class AdCoordinator: NSObject, GADFullScreenContentDelegate {
//    private var ad: GADInterstitialAd?
//    
//    override init() {
//        super.init()
//        loadAd()
//    }
//    
//    func loadAd() {
//        let request = GADRequest()
//        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        
//        GADInterstitialAd.load(
//            withAdUnitID: "ca-app-pub-7069513903308677/8780176633", request: request) { ad, error in
//                if let error = error {
//                    return print("Failed to load ad with error: \(error.localizedDescription)")
//                }
//                
//                self.ad = ad
//                self.ad?.fullScreenContentDelegate = self
//            }
//    }
//    
//    func presentAd() {
//        guard let fullScreenAd = ad else {
//            return print("Ad wasn't ready")
//        }
//        
//        // View controller is an optional parameter. Pass in nil.
//        fullScreenAd.present(fromRootViewController: nil)
//    }
//    
//    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
//        print("\(#function) called")
//    }
//    
//    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
//        print("\(#function) called")
//    }
//
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("\(#function) called")
//    }
//
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("\(#function) called")
//    }
//
//    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("\(#function) called")
//    }
//
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("\(#function) called")
//        loadAd()
//    }
//}
