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
    @State private var responses: [Response] = []
    @State private var errorMessage: String? = nil
    @State private var showAlert: Bool = false
    @State private var scrollPosition: String?
    
    private let responseRepository: ResponseRepository
    
    init(responseRepository: ResponseRepository) {
        self.responseRepository = responseRepository
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView(.vertical) {
                        ResponseStatsView(responses: responses)
                            .frame(height: 250)
                        
                        SentimentSummaryView(responses: responses)
                        
                        Text("Overview section")
                        
                        ForEach(responses, id: \.id) { response in
                            ResponseView(response: response)
                                .id(response.id)
                        }
                        .padding(.horizontal, 16.0)
                    }
                    .scrollPosition(id: $scrollPosition)
                    .scrollDismissesKeyboard(.interactively)
                    .padding(.bottom, 80)
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    BottomFieldView()
                }
            }
            .background(Color(uiColor: UIColor.groupTableViewBackground))
            .navigationTitle("Ask your AI")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(
            errorMessage ?? "Something went wrong",
            isPresented: $showAlert,
            actions: {}
        )
        .onChange(of: errorMessage, { _, newValue in
            showAlert = newValue != nil
        })
        .task {
            await fetchResponses()
        }
    }
    
    private func fetchResponses() async {
        do {
            self.responses = try await responseRepository.fetchResponses()
        } catch {
            self.errorMessage = error.localizedDescription
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
                        onDoneTapped()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .padding()
                            .foregroundStyle(.white)
                    }
                    .background(inputText.isEmpty ? Color.gray : Color.accentColor)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .disabled(inputText.isEmpty)
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
            .glassEffect()
            .padding(.horizontal)
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
    
    // TODO: move business logic to the ViewModel
    
    private func onDoneTapped() {
        guard !inputText.isEmpty else {
            return
        }
        
        let response = saveResponse(inputText)
        inputText = ""
        
        withAnimation {
            scrollPosition = response.id
        }
    }
    
    @discardableResult
    private func saveResponse(_ text: String) -> Response {
        let scorer = Scorer()
        let response = Response(
            id: NSUUID().uuidString,
            text: text,
            score: scorer.score(text)
        )
        
        self.responses.append(response)
        return response
    }
}

#Preview {
    RootView(
        responseRepository: ResponseRepositoryImplementation(
            responseDataSource: MockResponseDataSource(
                scorer: Scorer()
            )
        )
    )
}
