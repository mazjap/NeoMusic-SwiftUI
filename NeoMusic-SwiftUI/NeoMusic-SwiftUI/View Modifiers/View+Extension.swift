import SwiftUI

extension View {
    
    // MARK: - Functions
    
    func asAny() -> AnyView {
        AnyView(self)
    }
    
    func spacing(_ edges: Edge.Set = .all) -> some View {
        self
            .padding(edges, Constants.spacing)
    }
    
    func frame(size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    // Conditionally modify view
    @ViewBuilder
    func `if`<TrueContent, FalseContent>(_ condition: Bool,
                       trueModification: (Self) -> TrueContent) ->
                       some View where TrueContent: View, FalseContent: View {
        if condition {
            trueModification(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TrueContent, FalseContent>(_ condition: Bool,
                       trueModification: (Self) -> TrueContent,
                       else falseModification: ((Self) -> FalseContent)) ->
                       some View where TrueContent: View, FalseContent: View {
        if condition {
            trueModification(self)
        } else {
            falseModification(self)
        }
    }
    
    @_disfavoredOverload
    func onChange<Element: Equatable>(of element: Element, priority: TaskPriority? = nil, action: @escaping (Element) async -> Void) -> some View {
        self.onChange(of: element) { element in
            Task {
                await action(element)
            }
        }
    }
    
    func onAppear(priority: TaskPriority? = nil, action: @escaping () async -> Void) -> some View {
        return self.onAppear {
            Task {
                await action()
            }
        }
    }
}

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
