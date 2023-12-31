//
//  SettingView.swift
//  NaOng
//
//  Created by seohyeon park on 2023/07/20.
//

import SwiftUI
import UIKit

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var settingViewModel: SettingViewModel
    
    init(settingViewModel: SettingViewModel) {
        self.settingViewModel = settingViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            Text("설정")
                .foregroundStyle(.black)
                .font(.custom("Binggrae-Bold", size: 30))
            
            Button {
                settingViewModel.showNotificationAlert()
            } label: {
                HStack {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    Text("알림 설정")
                        .font(.custom("Binggrae", size: 16))
                    
                    Spacer()
                    
                    Text(settingViewModel.authorizationStatus)
                        .font(.custom("Binggrae", size: 16))
                        .foregroundStyle(.gray)
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.black)
            .alert("앱의 알림 설정으로 이동합니다.\n이동하는 화면에서 알림을 허용해 주세요.", isPresented: $settingViewModel.isShowingNotificationAlert) {
                Button("취소", role: .cancel) { }
                Button("확인", role: .destructive) {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
            }
            
            Button {
                if MailView.canSendMail {
                    settingViewModel.showEmailView()
                } else {
                    settingViewModel.showEmailAlert()
                }
            } label: {
                HStack {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    Text("문의 하기")
                        .font(.custom("Binggrae", size: 16))
                }
                .foregroundStyle(.black)
            }
            .sheet(isPresented: $settingViewModel.isShowingEmail) {
                MailView()
                    .tint(.accentColor)
            }
            .alert(isPresented: $settingViewModel.isShowingEmailAlert) {
                Alert(
                    title: Text("문의하려면 Mail 앱이 필요합니다."),
                    message: Text("앱스토어에서 Mail 앱을 다운받으시거나 naongofficial@gmail.com으로 직접 문의해주시면 감사하겠습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

