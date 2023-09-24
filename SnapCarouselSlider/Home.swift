//
//  Home.swift
//  SnapCarouselSlider
//
//  Created by Aleph-9Q05D on 24/09/23.
//

import SwiftUI

struct Home: View {
    @State var currentIndex: Int = 0
    
    @State var items: [OnboardingItem] = []
    
    var body: some View {
        VStack(spacing: 15 ) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    
                } label: {
                    Label {
                        Text ("Back")
                    } icon: {
                        Image (systemName: "chevron.left")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.primary)
                }
                
                Text("My Wishes")
                    .font(.title)
                    .fontWeight(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            //Snap carousel here
            SnapCarousel(index: $currentIndex, items: items,spacing: 13, trailingSpace: 50, isFirstItemCentered: true) { item in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: .infinity, height: 500)
                    .cornerRadius(12)
//                GeometryReader { proxy in
//                    let size = proxy.size
//
//
//                }
                
            }
            .padding(.vertical, 80)
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
