//
//  Home.swift
//  ControlcCenteriOS
//
//  Created by Anas Hamad on 2/6/23.
//

import SwiftUI

struct Home: View {
    @State private var brightnessConfig: ControlMod = .init()
    @Namespace private var namespace
    var body: some View {
        ZStack{
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 45, opaque: true)
                
                
            
            VStack() {
                HStack{
                    
                    
                    activeControls
                    
                        .frame(width: 100,height: 200,alignment: .center)
                        .padding(.vertical,15)
                        .padding(.horizontal,25)
                    
                }
            }
        }
    }
    
    var activeControls:some View{
        HStack(spacing: 15){
            
            CustomSlider(sliderImage: "sun.max.fill", animationID: "EXPANDBRIGHTNESS", namespaceID: namespace, showing:!brightnessConfig.expand , model: $brightnessConfig)
            
            .opacity(brightnessConfig.showContent ? 0 : 1)
            
           
        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
struct CustomSlider: View{
    var sliderImage: String
    var animationID: String
    /// - Since When We Expand Our Slider, Corner Radius will be Differed
    var cornerRadius: CGFloat = 18
    var namespaceID: Namespace.ID
    /// - Used to Show/Hide Between MatchedGeometry Effect
    var showing: Bool
    @Binding var model: ControlMod
    
    var body: some View{
        GeometryReader{
            let size = $0.size
            
            ZStack{
                if showing{
                    Rectangle()
                        .fill(.thinMaterial)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.white)
                                .scaleEffect(y: model.progress, anchor: .bottom)
                        }
                        .overlay(alignment: .bottom) {
                            Image(systemName: sliderImage,variableValue: model.progress)
                                .font(.title)
                                .blendMode(.exclusion)
                                .foregroundColor(.gray)
                                .padding(.bottom,20)
                                /// - For Expanded View it's Not Necessary
                                .opacity(model.animateContent && showing ? 0 : 1)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: model.animateContent ? cornerRadius : 18, style: .continuous))
                        .animation(.easeInOut(duration: 0.2), value: model.animateContent)
                        .scaleEffect(model.shrink ? 0.95 : 1)
                        .animation(.easeInOut(duration: 0.25), value: model.shrink)
                        .matchedGeometryEffect(id: animationID, in: namespaceID)
                }
            }
            /// - Adding Gesture
            .gesture(
                DragGesture().onChanged({ value in
                    if !model.shrink{
                        /// - Converting Offset Into Progress
                        let startLocation = value.startLocation.y
                        let currentLocation = value.location.y
                        let offset = startLocation - currentLocation
                        /// - Converting It Into Progress
                        var progress = (offset / size.height) + model.lastProgress
                        /// - Clipping Progress btw 0 - 1
                        progress = max(0, progress)
                        progress = min(1, progress)
                        model.progress = progress
                    }
                }).onEnded({ value in
                    /// - Saving Last Progress for Continous Flow
                    model.lastProgress = model.progress
                })
            )
        }
    }
    

}
