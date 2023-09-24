//
//  OnboardingItem.swift
//  SnapCarouselSlider
//
//  Created by Aleph-9Q05D on 24/09/23.
//

import SwiftUI

struct OnboardingItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String 
}

struct OnboardingItemView: View {
    var body: some View {
        VStack {
            Image("onboarding-consultation")
        }
    }
}

//struct OnboardingItem_Previews: PreviewProvider {
//    static var previews: some View {
////        C()
//    }
//}
