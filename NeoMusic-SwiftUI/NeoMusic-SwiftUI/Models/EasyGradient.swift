import SwiftUI

struct EasyGradient: Codable, Hashable, Identifiable, CustomStringConvertible, RawRepresentable {
    // MARK: - Variables
    
    var rawValue: String {
        do {
            if let value = String(data: try JSONEncoder().encode(self), encoding: .utf8) {
                return value
            }
        } catch {
            print(error)
        }
        
        return "[]"
    }
    
    var description: String {
        "\(easyColors)"
    }
    
    var id: String {
        rawValue
    }
    
    private(set) var easyColors: [EasyColor]
    
    var count: Int {
        easyColors.count
    }
    
    var colors: [Color] {
        easyColors.map { $0.color }
    }
    
    var uiColors: [UIColor] {
        easyColors.map { $0.uiColor }
    }
    
    var gradient: Gradient {
        Gradient(colors: colors)
    }
    
    var first: Color {
        return easyColors.first?.color ?? .clear
    }
    
    var last: Color {
        return easyColors.last?.color ?? .clear
    }
    
    // MARK: - Initializers
    
    init(_ colors: [Color]) {
        var items = [EasyColor.none]
        
        if colors.count > 0 {
            items = colors.map { EasyColor($0) }
        }
        
        self.init(items)
    }
    
    init(_ colors: [EasyColor]) {
        var items = [EasyColor.none]
        
        if colors.count > 0 {
            items = colors
        }
        
        self.easyColors = items
    }
    
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let value = try? JSONDecoder().decode(EasyGradient.self, from: data)
        else {
            return nil
        }
        
        self = value
    }
    
    // MARK: - Functions
    
    subscript(i: Int) -> EasyColor {
        guard i >= 0 else { return easyColors[0] }
        guard i < easyColors.count else {return easyColors[easyColors.count - 1]}
        return easyColors[i]
    }
    
    mutating func addColor(_ color: EasyColor, at i: Int? = nil) {
        if colors.count == 1 && colors[0] == .clear {
            easyColors[0] = color
            return
        }
        
        if let index = i, index <= count, index >= 0 {
            easyColors.insert(color, at: index)
        } else {
            easyColors.append(color)
        }
    }
    
    mutating func addColor(_ color: Color, at i: Int? = nil) {
        addColor(EasyColor(color), at: i)
    }
    
    @discardableResult
    mutating func removeColor(at index: Int) -> EasyColor? {
        guard count != 0, index >= 0, index < count else { return nil }
        
        let ezclr = easyColors.remove(at: index)
        if count == 0 {
            addColor(EasyColor.none.color)
        }
        
        return ezclr
    }
    
    mutating func replaceColor(at index: Int, with color: EasyColor) {
        removeColor(at: index)
        addColor(color, at: index)
    }
    
    mutating func replaceColor(at index: Int, with color: Color) {
        replaceColor(at: index, with: EasyColor(color))
    }
    
    func color(at index: Int) -> Color {
        let ezclr: EasyColor
        
        if count == 0 {
            ezclr = .none
        } else if index >= easyColors.count {
            ezclr = easyColors[easyColors.count - 1]
        } else if index < 0 {
            ezclr = easyColors[0]
        } else {
            ezclr = easyColors[index]
        }
        
        return ezclr.color
    }
    
    static let none = EasyGradient([EasyColor.clear])
}

extension EasyGradient {
    enum CodingKeys: String, CodingKey {
        case easyColors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.easyColors = try container.decode([EasyColor].self, forKey: .easyColors)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(easyColors, forKey: .easyColors)
    }
}

// MARK: Gradient Extension: reversed

extension Gradient {
    var reversed: Gradient {
        Gradient(colors: stops.map { $0.color }.reversed())
    }
    
    var caGradient: CAGradientLayer {
        let g = CAGradientLayer()
        g.colors = [stops.map { $0.color.uiColor.cgColor }]
        g.startPoint = CGPoint(x: 0.5, y: 1.0)
        g.endPoint = CGPoint(x: 0.5, y: 0.0)
        g.locations = [0, 1]
        
        return g
    }
}
