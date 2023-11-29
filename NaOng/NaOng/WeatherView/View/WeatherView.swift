//
//  WeatherView.swift
//  NaOng
//
//  Created by seohyeon park on 11/22/23.
//

import SwiftUI
import PhotosUI

struct WeatherView: View {
    @ObservedObject private var weatherViewModel: WeatherViewModel
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }

    var body: some View {
        VStack {
            if weatherViewModel.isLoading {
                ProgressView("Loading...")
            } else {
                HStack {
                    Image("mapIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(weatherViewModel.currentLocation ?? "알 수 없음")
                        .font(.custom("Binggrae", size: 15))
                    
                    Spacer()
                    
                    Menu {
                        Button("이름 수정하기") {
                            weatherViewModel.showProfileNameEditAlert()
                        }
                        
                        Button("사진 수정하기") {
                            weatherViewModel.showPhotosPicker()
                        }
                        
                        Button("기본 사진으로 변경하기") {
                            weatherViewModel.setupBasicProfileImage()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .photosPicker(isPresented: $weatherViewModel.isShowingPhotosPicker, selection: $weatherViewModel.imageSelection)
                    .alert("수정할 이름을 적어주세요.", isPresented: $weatherViewModel.isShowingProfileNameEditAlert) {
                        TextField("수정할 이름을 적어주세요.", text: $weatherViewModel.profileName)

                        Button("완료", role: .destructive) {
                            weatherViewModel.submit()
                        }
                        .disabled(weatherViewModel.verifyProfileName())
                        Button("취소", role: .cancel) { }
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 2)
                    .foregroundStyle(.black)

                List(weatherViewModel.contents, id: \.self) { content in
                    WeatherItemView(imageState: weatherViewModel.imageState, profileName: UserDefaults.standard.string(forKey: "weatherViewProfileName") ?? "나옹", context: content)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            weatherViewModel.setUpCurrentLocation()
        }
    }
}