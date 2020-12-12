//
//  SettingsBar.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/1/20.
//

import SwiftUI

struct SettingsBar: View {
    @EnvironmentObject private var settingsController: SettingsController
    @State private var showingColorSchemeEditor = false
    
    @Binding private var isOpen: Bool
    
    private let backgroundColor: Color
    private let nspace: Namespace.ID
    
    init(backgroundColor: Color, namespace: Namespace.ID, isOpen: Binding<Bool>) {
        self.backgroundColor = backgroundColor
        self.nspace = namespace
        self._isOpen = isOpen
    }
    
    var body: some View {
        VStack {
            ZStack {
                backgroundColor
                    .cornerRadius(20)
                HStack {
                    Button(action: {
                        withAnimation {
                            showingColorSchemeEditor.toggle()
                        }
                    }) {
                        Image("colorscheme_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
                    }
                    .buttonStyle(DefaultButtonStyle(color: backgroundColor, padding: Constants.buttonPadding - 10))
                    .frame(width: Constants.buttonSize - 20, height: Constants.buttonSize - 20)
                    
                    Spacer()
                    
                    BarButton(systemImageName: "xmark.circle.fill", buttonColor: settingsController.colorScheme.textColor.color) {
                        withAnimation {
                            isOpen = false
                        }
                    }
                    .matchedGeometryEffect(id: "BarButton", in: nspace)
                }
                .padding(.horizontal, Constants.spacing / 2)
            }
            .frame(height: Self.height)

            if showingColorSchemeEditor {
                ColorSchemeView(backgroundColor: backgroundColor)
            } else { // if (other cases) {

            }
        }
    }
    
    static var height: CGFloat = 100
}

struct SettingsBar_Previews: PreviewProvider {
    @Namespace static private var nspace
    @State static private var isOpen: Bool = true
    
    static var previews: some View {
        SettingsBar(backgroundColor: .falseBlack, namespace: nspace, isOpen: $isOpen)
    }
}
