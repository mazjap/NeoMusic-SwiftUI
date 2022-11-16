import SwiftUI

extension UIColor {
    var hsb: (h: CGFloat, s: CGFloat, b: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: nil) else {
            return (-1, -1, -1)
        }
        
        return (h, s, b)
    }
    
    var rgb: (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: nil) else {
            return (-1, -1, -1)
        }

        return (r, g, b)
    }
    
    var offsetColors: [UIColor] {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
        // If colors brightness is greater than 0.9 or less than 0.1
        //     Use self as one of the offsets and offset the other color's brightness by 0.2
        // Else
        //     offset the color's brightness by 0.1 in both directions
        
        if b - 0.1 < 0 {
            return [
                UIColor(hue: h, saturation: s, brightness: 0, alpha: 1),
                UIColor(hue: h, saturation: s, brightness: 0.1, alpha: 1)
            ]
        } else if b + 0.1 > 1 {
            return [
                UIColor(hue: h, saturation: s, brightness: 0.9, alpha: 1),
                UIColor(hue: h, saturation: s, brightness: 1, alpha: 1)
            ]
        } else {
            return [
                UIColor(hue: h, saturation: s, brightness: b - 0.1, alpha: 1),
                UIColor(hue: h, saturation: s, brightness: b + 0.1, alpha: 1)
            ]
        }
    }
}

extension Color {
    static let defaultGradientTop = Color("DefaultGradientTop")
    static let defaultGradientBottom = Color("DefaultGradientBottom")
    
    static let sliderGradientTop = Color("SliderGradientDark")
    static let sliderGradientBottom = Color("SliderGradientLight")
    
    static let playGradientTop = Color("PlayGradientDark")
    static let playGradientBottom = Color("PlayGradientLight")
    
    static let falseWhite = Color(red: 0.92, green: 0.92, blue: 0.98)
    static let falseBlack = Color(red: 0.08, green: 0.08, blue: 0.12)
    
    static let lightGray = Color(UIColor.lightGray)
    
    var rgb: (r: Double, g: Double, b: Double) {
        let vals = uiColor.rgb
        return (Double(vals.r), Double(vals.g), Double(vals.b))
    }
    
    var hsb: (h: Double, s: Double, b: Double) {
        let vals = uiColor.hsb
        return (Double(vals.h), Double(vals.s), Double(vals.b))
    }
    
    // Credit to Darel Rex Finley: http://alienryderflex.com/hsp.html
    var perceivedBrightness: Double {
        let vals = rgb
        
        // brightness = sqrt(r^2 * 0.299 + g^2 * 0.587 + b^2 * 0.114)
        return sqrt(vals.r * vals.r * 0.299 + vals.g * vals.g * 0.587 + vals.b * vals.b * 0.114)
    }
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    var offsetColors: [Color] {
        uiColor.offsetColors.map { Color($0) }
    }
    
    var offsetGradient: Gradient {
        Gradient(colors: offsetColors)
    }
    
    func average(to color: Color, at percent: Double = 0.5) -> Color {
        let c1 = rgb
        let c2 = color.rgb
        
        return Color(red: c1.r + percent * (c2.r - c1.r), green: c1.g + percent * (c2.g - c1.g), blue:  c1.b + percent * (c2.b - c1.b))
    }
}
