//
//  BasicTableCell.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/19/20.
//

import SwiftUI

struct BasicTableCell: View {
    private let labelText: String
    private let image: Image?
    private let detailText: String?
    
    var text: String {
        labelText
    }
    
    init(label: String, detail: String?, image: Image? = nil) {
        self.labelText = label
        self.detailText = detail
        self.image = image
    }
    
    var body: some View {
        HStack(spacing: 7) {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: Self.rowHeight - 5, height: Self.rowHeight - 5)
            }
            
            VStack(alignment: .leading) {
                Text(labelText)
                    .font(.body)
                
                if let detail = detailText {
                    Text(detail)
                        .font(.caption)
                }
            }
            .spacing(.vertical)
            
            Spacer()
        }
        .frame(height: Self.rowHeight)
    }
    
    static let rowHeight: CGFloat = 30
}

struct UpNextRow_Previews: PreviewProvider {
    @State static var selected: AMSong = .noSong
    
    static var previews: some View {
        BasicTableCell(label: "Hello, World!", detail: "Hi, Universe!")
    }
}


@resultBuilder
struct BasicCellBuilder {
    static func buildBlock(_ children: BasicTableCell...) -> [BasicTableCell] {
        children
    }
}
