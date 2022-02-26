//
//  ProfileView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/22/20.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicController
    
    @State private var showSettingsBar: Bool = false
    @State private var profileRoation: Double = 0
    
    @State private var promoText: String = ""
    
    @Namespace private var nspace
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.largeTitle)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                    
                    settingsTable
                    
                    Spacer()
                    
                    
                }
                .padding(.top, 50)

                Spacer()
                
                // TODO: - App info
            }
            .padding(.leading, 20)
        }
//        NavigationView {
//            ScrollView(.vertical) {
//                LazyVStack {
//
//                }
//            }
//            .navigationBarTitle("Settings")
//        }
        
//        ZStack {
//            VStack {
//                HStack {
//                    if showSettingsBar {
//                        Spacer()
//                            .frame(height: BarButton.size)
//                    } else {
//                        Spacer()
//
//                        BarButton(systemImageName: "gearshape.fill", buttonColor: settingsController.colorScheme.textColor.color) {
//                            withAnimation {
//                                showSettingsBar = true
//                            }
//                        }
//                        .matchedGeometryEffect(id: "BarButton", in: nspace)
//                        .spacing(.trailing)
//                    }
//                }
//
//                RotatableImage(colorScheme: settingsController.colorScheme, image: .placeholder /* TODO: - Use user icon */, rotation: $profileRoation)
//                    .frame(height: 200, width: 200)
//
//                Text("Username")
//                    .font(.title)
//                    .foregroundColor(settingsController.colorScheme.textColor.color)
//
//                Spacer()
//            }
//
//            if showSettingsBar {
//                VStack {
//                    SettingsBar(backgroundColor: settingsController.colorScheme.backgroundGradient.first, namespace: nspace, isOpen: $showSettingsBar)
//                        .padding(.horizontal, Constants.spacing / 2)
//
//                    Spacer()
//                }
//            }
//        }
    }
    
    private var settingsTable: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                // Theme
                TableItem.label(
                    label("Theme")
                )
                // Connected Accounts
                TableItem.label(
                    label("Connected Accounts")
                )
//                // App Icon
//                TableItem.label(
//                    label("App Icon"),
//                    .link(<#T##AnyView#>, .white)
//                )
                TableItem.label(
                    label("Restore Purchases"),
                    .onTap({
                        // TODO: - Restore Purchase
                    }, .white)
                )
                TableItem.custom(
                    HStack {
                        TextField("Promo", text: $promoText)
                            .background(RoundedRectangle(cornerRadius: 4).foregroundColor(.white))
                        
                        Button(action: {
                            // TODO: - Promo code
                            
                        }, label: {
                            Text("Submit")
                        })
                    }.asAny()
                )
            }
        }
    }
    
    private func label(_ text: String) -> Text {
        Text(text)
            .foregroundColor(settingsController.colorScheme.textColor.color)
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let setCon = SettingsController.shared
        
        ZStack {
            LinearGradient(gradient: setCon.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
            
            ProfileView()
                .environmentObject(setCon)
                .environmentObject(MusicController())
        }
    }
}

struct NavigatableList {
    private var content: [TableItem]
}

//protocol TableItem {
//    var row: AnyView { get }
//}
//
//extension TableItem {
//    var seperator: some View {
//        Rectangle()
//            .frame(height: 1)
//            .foregroundColor(.white)
//    }
//}
//
//struct CustomTableItem<Content>: View, TableItem where Content: View {
//    let content: () -> Content
//
//    var body: some View {
//        VStack {
//            HStack {
//                content()
//
//                Spacer()
//            }
//        }
//    }
//
//    var row: AnyView {
//        VStack {
//            body
//
//            seperator
//        }.asAny()
//    }
//}
//
//struct NavigationTableItem: View, TableItem {
//    let label: Text
//
//    var body: some View {
//        VStack {
//            HStack {
//                label
//
//                Spacer()
//
//                Image(systemName: "chevron.right")
//            }
//        }
//    }
//
//    var row: AnyView {
//        VStack {
//            body
//
//            seperator
//        }.asAny()
//    }
//}

enum TableItem: View {
    case custom(AnyView, TableAction? = nil)
    case label(Text, TableAction? = nil)
    
    var tableAction: TableAction? {
        switch self {
        case let .label(_, tableAction):
            return tableAction
        case let .custom(_, tableAction):
            return tableAction
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                switch self {
                case let .label(text, _):
                    text
                case let .custom(view, _):
                    view
                }

                Spacer()
                
                if let tableAction = tableAction {
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundColor(tableAction.color)
                }
            }
            
            seperator
        }
    }
    
    private var seperator: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.white)
    }
    
    enum TableAction {
        case onTap(() -> Void, Color)
        case link(AnyView, Color)
        
        var color: Color {
            switch self {
            case let .onTap(_, color):
                return color
            case let .link(_, color):
                return color
            }
        }
    }
}
