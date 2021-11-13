//
//  CustomAlertView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 11/11/21.
//

import SwiftUI

struct OkImage: View {
    var body: some View {
        Image(systemName:"checkmark.circle.fill")
            .font(.system(size: 50, weight: .medium))
            .foregroundColor(.green)
    }
}

struct ErrorImage: View {
    var body: some View {
        Image(systemName:"x.circle.fill")
            .font(.system(size: 50, weight: .medium))
            .foregroundColor(.red)
    }
}

struct CustomAlertView: View {

    var mode: Mode
    var message: [LocalizedStringKey]
    var okText: LocalizedStringKey = "Ok"
    var dismissText: LocalizedStringKey = "Close"
    var action: (String) -> Void

    enum Mode {
        case success
        case failure
    }

    var body: some View {
        VStack {
            switch mode {
            case .success:
                OkImage()
                    .padding(.top)
                Spacer()
                ForEach(message, id: \.self) { text in
                    Text(text).foregroundColor(Color.white).multilineTextAlignment(.center)
                }
            case .failure:
                ErrorImage()
                    .padding(.top)
                Spacer()
                ForEach(message, id: \.self) { text in
                    Text(text).foregroundColor(Color.white).multilineTextAlignment(.center)
                }
            }
            Spacer()
            Divider()
            HStack {
                Button(dismissText) {
                    action("dismiss")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                Button(okText) {
                    action("ok")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width/2-30, height: 40)
            }
        }
        .frame(width: UIScreen.main.bounds.width-50, height: 280)
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
        .shadow(radius: 20)
    }
}

//struct CustomAlertView_Previews: PreviewProvider {
//    static let text: LocalizedStringKey = "Short text sample"
//    static var previews: some View {
//        CustomAlertView(mode: .success, text: text, action: { _ in
//
//        })
//            .environment(\.locale, .init(identifier: "es"))
//    }
//}
