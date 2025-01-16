//
//  PageView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/16/25.
//

import SwiftUI

import SwiftUI

struct PageView: View {
    let title: String
    let subheading: String
    let imageName: String
    let direction: Direction

    enum Direction {
        case left
        case right
    }

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(subheading)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            ZStack {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    
                    Path { path in
                        if direction == .left {
                            // Left-leaning shape
                            path.move(to: CGPoint(x: width, y: width * 0.3))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: width * 0.8))
                            path.addLine(to: CGPoint(x: width, y: width))
                        } else {
                            // Right-leaning shape
                            path.move(to: CGPoint(x: 0, y: width * 0.3))
                            path.addLine(to: CGPoint(x: width, y: 0))
                            path.addLine(to: CGPoint(x: width, y: width * 0.8))
                            path.addLine(to: CGPoint(x: 0, y: width))
                        }
                        path.closeSubpath()
                    }
                    .fill(Color.white)
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .position(x: 190, y: 225)

                }
                .frame(height: 300)
            }
            .padding(.bottom, 20)
            
            Spacer()
        }
    }
}

#Preview {
    PageView(
        title: "Welcome to Screen Therapy",
        subheading: "Discover balance & productivity. Take control of your time and start living today.",
        imageName: "ShieldLogo",
        direction: .right
    )
}
