//
//  RootView.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import SwiftUI

struct RootView: View {
    @State private var shouldStartAnimation: Bool = false
    @State private var gradientStops: [Gradient.Stop] = []
    @State private var inputText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    Text("Chart")
                    
                    Text("Overview section")
                    
                    ForEach(0..<10) { response in
                        Text(response.description)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                
                BottomFieldView()
            }
        }
    }
    
    @ViewBuilder
    private func BottomFieldView() -> some View {
        
        VStack(alignment: .center) {
            HStack(alignment: .bottom) {
                HStack {
                    TextField(
                        "Your thoughts",
                        text: $inputText
                    )
                    .onTapGesture {
                        shouldStartAnimation = true
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .padding()
                            .foregroundStyle(.white)
                    }
                    .background(.tint)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                }
                .padding()
            }
            .background(.ultraThickMaterial)
            .clipShape(
                RoundedRectangle(cornerRadius: 24.0)
            )
            .shadow(
                color: Color.gray.opacity(0.25),
                radius: 10
            )
            .padding(.horizontal)
            .padding(.bottom, 16.0)
            .overlay {
                if shouldStartAnimation {
                    GlowEffect(gradientStops: gradientStops)
                        .onAppear {
                            gradientStops = GlowEffect.generateGradientStops()
                        }
                }
            }
        }
    }
}

#Preview {
    RootView()
}
