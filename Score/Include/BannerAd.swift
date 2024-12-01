//
//  BannerAd.swift
//  Score
//
//  Created by Thomas Meyer on 01/12/2024.
//

import SwiftUI
import GoogleMobileAds


//struct BannerView: UIViewRepresentable {
//    let adSize: GADAdSize
//    
//    init(_ adSize: GADAdSize) {
//        self.adSize = adSize
//    }
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        view.addSubview(context.coordinator.bannerView)
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//      context.coordinator.bannerView.adSize = adSize
//    }
//
//    func makeCoordinator() -> BannerCoordinator {
//      return BannerCoordinator(self)
//    }
//    
//    class BannerCoordinator: NSObject, GADBannerViewDelegate {
//        private(set) lazy var bannerView: GADBannerView = {
//          let banner = GADBannerView(adSize: parent.adSize)
//          banner.adUnitID = bannerID
//          banner.load(GADRequest())
//          banner.delegate = self
//          return banner
//        }()
//
//        let parent: BannerView
//
//        init(_ parent: BannerView) {
//          self.parent = parent
//        }
//
//        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//          print("DID RECEIVE AD.")
//        }
//
//        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//          print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
//        }
//      }
//}
