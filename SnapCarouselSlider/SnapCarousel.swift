//
//  SnapCarousel.swift
//  SnapCarouselSlider
//
//  Created by Aleph-9Q05D on 24/09/23.
//

import SwiftUI

struct SnapCarousel <Content: View, T: Identifiable>: View {
    private var content: (T) -> Content
    private var list: [T]
    
    //Properties
    private var spacing: CGFloat
    private var trailingSpace: CGFloat
    @Binding private var index: Int
    private var isFirstItemCentered: Bool
    
    init(
        index: Binding<Int>,
        items: [T],
        spacing: CGFloat = 15,
        trailingSpace: CGFloat = 100,
        isFirstItemCentered: Bool = true,
        @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
        self.isFirstItemCentered = isFirstItemCentered
    }
    
    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            
            let adjustmentWidth: CGFloat = {
                if isFirstItemCentered {
                    return (trailingSpace / 2) - spacing
                } else {
                    // Settings only after 0th index
                    return currentIndex != 0 ? (trailingSpace / 2) - spacing : 0
                }
            }()
            
            HStack (spacing: spacing){
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + adjustmentWidth + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        //updating index
                        let offsetX = value.translation.width
                        let progress =  -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                        print(">>> currentIndex: \(currentIndex)")
                    })
                    .onChanged({ value in
                        //updating index
                        let offsetX = value.translation.width
                        let progress =  -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        print(">>> index: \(index)")
                    })
            )
        }
        // Animation when offset == 0
        .animation(.easeInOut, value: offset == 0 )
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
