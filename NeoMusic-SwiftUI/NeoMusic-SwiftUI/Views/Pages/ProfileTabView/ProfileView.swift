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
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
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
            .edgesIgnoringSafeArea(.init(arrayLiteral: []))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var settingsTable: some View {
        TableView(data: .constant(SettingsItem.allCases)) { item in
            switch item {
            case .theme:
                NavigationLink {
                    ColorSchemeView(backgroundColor: .black)
                } label: {
                    Text("Theme")
                }
            case .connectedAccounts:
                NavigationLink {
                    
                } label: {
                    Text("Connected Accounts")
                }
            case .restorePurchases:
                Text("Restore Purchases")
                    .onTapGesture {
                        print("Need to implement")
                    }
            case .promoCode:
                HStack {
                    TextField("Promo", text: $promoText)
                        .background(RoundedRectangle(cornerRadius: 4).foregroundColor(.white))
                    
                    Button(action: {
                        // TODO: - Promo code
                        
                    }, label: {
                        Text("Submit")
                    })
                }
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

enum SettingsItem: CaseIterable {
    case theme
    case connectedAccounts
    case restorePurchases
    case promoCode
}
