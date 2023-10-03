//
//  ChangeCityView.swift
//  SUWeather
//
//  Created by Doni on 04/08/23.
//

import SwiftUI

struct ChangeCityView: View {
    
    // MARK: - PROPERTIES
    
    @State var showLoader: Bool = false
    @State var showStatusMessage: Bool = false
    @State var statusMessage: String = ""
    @State var changeCityTF: String = ""
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.self) var env
    
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(isNight: weatherViewModel.isNight).opacity(0.6)
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 20) {
                        Text("Enter City")
                            .font(.system(size: 25, weight: .semibold, design: .default))
                            .foregroundColor(.blue)
                        
                        TextField("", text: $changeCityTF, prompt: Text("City Name")
                            .foregroundColor(.gray).font(.headline))
                            .frame(width: 320, height: 44)
                            .multilineTextAlignment(.center)
                            .background(Color.white)
                            .cornerRadius(5)
                            .font(.headline)
                        
                        Button {
                            withAnimation {
                                self.showLoader = true
                                if changeCityTF.isEmpty {
                                    self.showLoader = false
                                    self.showStatusMessage = true
                                    self.statusMessage = "City cannot be empty. Please try again!"
                                } else {
                                    weatherViewModel.getWeather(byCity: changeCityTF)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        self.showLoader = false
                                        self.showStatusMessage = true
                                        self.statusMessage = weatherViewModel.messageStatus
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        env.dismiss()
                                    }
                                }
                            }
                        } label: {
                            CustomButton(title: "Search",
                                         textColor: .white,
                                         backgroundColor: .blue)
                        }
                        if showLoader {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding(.bottom,10)
                        }
                        if showStatusMessage {
                            Text(statusMessage)
                                .font(.system(size: 25, weight: .semibold, design: .default))
                                .foregroundColor(statusMessage == MessageStatus.success.rawValue ? .green : .red)
                        }
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.5)))
                    .padding(20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        env.dismiss()
                    } label: {
                        XDismissButton()
                    }
                }
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCityView()
    }
}

