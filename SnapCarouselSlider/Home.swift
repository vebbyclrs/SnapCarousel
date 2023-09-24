//
//  Home.swift
//  SnapCarouselSlider
//
//  Created by Vebby Clarissa on 24/09/23.
//

import SwiftUI

struct Home: View {
    @State var currentIndex: Int = 0
    
    @State var items: [OnboardingItem] = []
    
    var body: some View {
        VStack(spacing: 16 ) {
            //Snap carousel here
            SnapCarousel(index: $currentIndex, items: items) { item, isFocused  in
                GeometryReader { proxy in
                    let size = proxy.size
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: 500)
                        .cornerRadius(12)
                        .scaleEffect(isFocused ? 1.1 : 1)
                }
                
            }
            .padding(.vertical, 80)
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            for index in (1...5){
                items.append(OnboardingItem(image: "landmarks\(index)"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
