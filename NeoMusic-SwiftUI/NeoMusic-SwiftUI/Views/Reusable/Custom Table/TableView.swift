import SwiftUI

struct TableView<Data, ID, Row>: View where Row: View, Data: RandomAccessCollection, ID: Hashable {
    @Binding private var data: Data
    private let content: (Data.Element) -> Row
    private let id: KeyPath<Data.Element, ID>
    
    init(data: Binding<Data>, @ViewBuilder row: @escaping (Data.Element) -> Row) where ID == Data.Element {
        self.init(data: data, id: \.self, row: row)
    }
    
    init(data: Binding<Data>, id: KeyPath<Data.Element, ID>, @ViewBuilder row: @escaping (Data.Element) -> Row) {
        self._data = data
        self.id = id
        self.content = row
        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading) {
                ForEach(data, id: id, content: content)
            }
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(data: .constant([1, 2, 3])) { _ in
            EmptyView()
        }
    }
}
