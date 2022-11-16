import SwiftUI

class UserController: ObservableObject {
    @Published var user: User?
    
    var isLoggedIn: Bool {
        if let user = user {
            return !(user.token ?? "").isEmpty
        }
        
        return false
    }
    
    init() {
        self.user = nil
    }
    
    func login(using username: String, password: String) {
        
    }
    
    func logout() {
        user = nil
    }
    
    func addToFavorites(_ song: AMSong) {
        guard isLoggedIn else {
            // TODO: - Prompt log in
            return
        }
    }
    
    func isFavorite(_ song: AMSong) -> Bool {
        guard isLoggedIn else { return false }
        
        return true
    }
}
