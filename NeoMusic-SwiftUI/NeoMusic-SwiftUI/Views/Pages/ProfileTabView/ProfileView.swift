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
        NavigationView {
            ZStack {
                LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                settingsTable
            }
            .navigationTitle("Settings")
        }
    }
    
    private var settingsTable: some View {
        List {
            NavigationLink {
                ColorSchemeView(backgroundColor: .black)
            } label: {
                Text("Theme")
            }
            
            NavigationLink {
                
            } label: {
                Text("Connected Accounts")
            }
            
            Text("Restore Purchases")
                .onTapGesture {
                    print("Need to implement")
                }
            
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
        .onAppear {
            UIScrollView.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
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

enum SettingsItem: Int, CaseIterable {
    case theme
    case connectedAccounts
    case restorePurchases
    case promoCode
}
