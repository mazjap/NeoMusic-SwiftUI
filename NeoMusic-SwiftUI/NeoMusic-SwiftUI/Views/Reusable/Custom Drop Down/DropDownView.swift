import SwiftUI

struct DropDownView<Data, ID, Content>: View where ID: Hashable, Content: View {
    @Binding private var isOpen: Bool
    @Binding private var data: [Data]
    private let id: KeyPath<Data, ID>
    
    private let content: (Data) -> Content
    
    init(data: Binding<[Data]>, isOpen: Binding<Bool>, backgroundColor: Color?, @ViewBuilder _ content: @escaping (Data) -> Content) where Data == ID {
        self.init(data: data, id: \.self, isOpen: isOpen, backgroundColor: backgroundColor, content)
    }
    
    init(data: Binding<[Data]>, id: KeyPath<Data, ID>, isOpen: Binding<Bool>, backgroundColor: Color?, @ViewBuilder _ content: @escaping (Data) -> Content) {
        self._isOpen = isOpen
        self._data = data
        self.id = id
        self.content = content
    }
    
    var body: some View {
        TableView(data: $data, id: id, row: content)
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView(data: .constant(["First", "Second", "Third"]), isOpen: .constant(true), backgroundColor: .red) { string in
            Text(string)
        }
    }
}
