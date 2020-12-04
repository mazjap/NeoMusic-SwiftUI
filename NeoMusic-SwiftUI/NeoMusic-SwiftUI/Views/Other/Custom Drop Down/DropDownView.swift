//
//  DropDownView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/3/20.
//

import SwiftUI

typealias DropDownItem = BasicTableCell
typealias DropDownBuilder = BasicCellBuilder

struct DropDownView: View {
    @Environment(\.cellSpacing) private var spacing: CGFloat
    
    @State private var selectedIndex: IndexPath = .zero
    
    @Binding private var selectedItem: Int
    @Binding private var isOpen: Bool
    
    private let usesSeperator: Bool
    private let showsScrollingIndicator: Bool
    private let font: Font
    private let roundedCorners: CGFloat
    private let tableHeight: CGFloat
    private let cellColor: Color?
    private let textColor: Color
    
    private let background: Color
    
    private let items: [DropDownItem]
    
    init(isOpen: Binding<Bool> = .init(get: {return true}, set: {_ in}), selectedItem: Binding<Int> = .init(get: {return 0}, set: {_ in}), backgroundColor: Color? = nil, @DropDownBuilder _ content: () -> [DropDownItem]) {
        self.init(isOpen: isOpen, selectedItem: selectedItem, backgroundColor: backgroundColor, content())
    }
    
    private init(isOpen: Binding<Bool>, selectedItem: Binding<Int> = .init(get: {return 0}, set: {_ in}), backgroundColor: Color?, _ content: [DropDownItem], usesSeperator: Bool? = nil, showsScrollingIndicator: Bool? = nil, font: Font? = nil, roundedCorners: CGFloat? = nil, tableHeight: CGFloat? = nil, cellColor: Color? = nil, textColor: Color? = nil) {
        self.items = content
        self._selectedItem = selectedItem
        self._isOpen = isOpen
        self.usesSeperator = usesSeperator ?? false
        self.showsScrollingIndicator = showsScrollingIndicator ?? true
        self.font = font ?? .body
        self.background = backgroundColor ?? .black
        self.roundedCorners = roundedCorners ?? 0
        self.tableHeight = tableHeight ?? 100
        self.cellColor = cellColor
        self.textColor = textColor ?? .black
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(items[selectedItem].text)
                    .font(isOpen ? .body : font)
                    .spacing(.horizontal)
                    .onTapGesture {
                        isOpen = true
                    }
                
                if isOpen {
                    Spacer()
                }
            }
        
            if isOpen {
                Table(selectedIndexPath: $selectedIndex.onChanged(indexChanged(to:))) {
                    ForEach(0..<items.count) { i in
                        items[i]
                            .foregroundColor(cellColor)
                    }
                }
                .usesSeperator(usesSeperator)
                .showsScrollingIndicator(showsScrollingIndicator)
                .background(background.cornerRadius(roundedCorners))
                .cornerRadius(roundedCorners)
                .frame(height: tableHeight)
            }
            
            Spacer()
        }
    }
    
    func indexChanged(to index: IndexPath) {
        selectedItem = index.item
        
        withAnimation {
            isOpen = false
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView {
            DropDownItem(label: "Hello, World!", detail: nil)
            
            DropDownItem(label: "Hey, Creator!", detail: "- A message from the program")
        }
    }
}

extension DropDownView {
    func usesSeperator(_ bool: Bool) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: bool, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: roundedCorners, tableHeight: tableHeight, cellColor: cellColor, textColor: textColor)
    }
    
    func showsScrollingIndicator(_ bool: Bool) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: bool, font: font, roundedCorners: roundedCorners, tableHeight: tableHeight, cellColor: cellColor, textColor: textColor)
    }
    
    func font(_ font: Font) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: roundedCorners, tableHeight: tableHeight, cellColor: cellColor, textColor: textColor)
    }
    
    func roundedCorners(_ value: CGFloat) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: value, tableHeight: tableHeight, cellColor: cellColor, textColor: textColor)
    }
    
    func tableHeight(_ height: CGFloat) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: roundedCorners, tableHeight: height, cellColor: cellColor, textColor: textColor)
    }
    
    func cellColor(_ color: Color?) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: roundedCorners, tableHeight: tableHeight, cellColor: color)
    }
    
    func textColor(_ color: Color) -> Self {
        DropDownView(isOpen: $isOpen, selectedItem: $selectedItem, backgroundColor: background, items, usesSeperator: usesSeperator, showsScrollingIndicator: showsScrollingIndicator, font: font, roundedCorners: roundedCorners, tableHeight: tableHeight, cellColor: color, textColor: color)
    }
    
    func cellSpacing(_ amount: CGFloat) -> some View {
        self
            .environment(\.cellSpacing, amount)
    }
}
