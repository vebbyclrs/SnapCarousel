//
//  SnapCarousel.swift
//  SnapCarouselSlider
//
//  Created by Vebby Clarissa on 24/09/23.
//

import SwiftUI

enum SnapCarouselStyle {
    case focusAlwaysOnCenter
    case focusAlwaysOnLeading
    case startInLeadingThenCenter
}

/// By default, the style is assign as focus always on center. This will affect how you put the value inside the initializer
struct SnapCarousel <Content: View, T: Identifiable>: View {
    private var content: (T, Bool) -> Content
    private var list: [T]
    
    //Properties
    private var spacing: CGFloat
    private var widthOfHiddenCard: CGFloat
    @Binding private var index: Int
    private let style: SnapCarouselStyle
    
    /// By default, the style is assign as focus always on center. This will affect how you put the value inside these parameters
    /// - Parameters:
    ///   - index: Will be updated when the focus changed to this index
    ///   - items: List of item you wish to show
    ///   - widthOfHiddenCard: In the `.focusAlwaysOnLeading` style, the item will appear 2 times wider than the number you put here
    init(index: Binding<Int>,
         items: [T],
         style: SnapCarouselStyle = .focusAlwaysOnCenter,
         spacing: CGFloat = 16,
         widthOfHiddenCard: CGFloat = 100,
         @ViewBuilder content: @escaping (T, Bool) -> Content) {
        self.list = items
        self.spacing = spacing
        self.widthOfHiddenCard = widthOfHiddenCard
        self._index = index
        self.content = content
        self.style = style
    }
    
    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - (((2*widthOfHiddenCard) + (2*spacing)))
            let adjustmentWidth: CGFloat = {
                switch style {
                case .focusAlwaysOnCenter:
                    return (widthOfHiddenCard) + spacing/2
                case .focusAlwaysOnLeading:
                    return 0
                case .startInLeadingThenCenter:
                   return currentIndex != 0 ? (widthOfHiddenCard) : 0
                }
            }()
            
            HStack (spacing: spacing){
                ForEach(Array(zip(list.indices, list)), id: \.0) { index, item in
                    content(item, index == currentIndex)
                        .frame(width: width)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: CGFloat(currentIndex) * -(width + spacing) + offset + adjustmentWidth)
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
                        
                    })
                    .onChanged({ value in
                        //updating index
                        let offsetX = value.translation.width
                        let progress =  -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
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
