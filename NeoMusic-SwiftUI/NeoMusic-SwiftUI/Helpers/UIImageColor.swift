//
//  UIImageColors.swift
//  https://github.com/jathu/UIImageColors
//
//  Created by Jathu Satkunarajah (@jathu) on 2015-06-11 - Toronto
//  Based on Cocoa version by Panic Inc. - Portland
//

import UIKit

public struct UIImageColors {
    public var background: UIColor!
    public var primary: UIColor!
    public var secondary: UIColor!
    public var detail: UIColor!
  
    public init(background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
      self.background = background
      self.primary = primary
      self.secondary = secondary
      self.detail = detail
    }
}

public enum UIImageColorsQuality: CGFloat {
    case lowest = 50 // 50px
    case low = 100 // 100px
    case high = 250 // 250px
    case highest = 0 // No scale
}

fileprivate struct UIImageColorsCounter {
    let color: Double
    let count: Int
    init(color: Double, count: Int) {
        self.color = color
        self.count = count
    }
}

/*
    Extension on double that replicates UIColor methods. We DO NOT want these
    exposed outside of the library because they don't make sense outside of the
    context of UIImageColors.
*/
fileprivate extension Double {
    
    private var r: Double {
        return fmod(floor(self / 1000000), 1000000)
    }
    
    private var g: Double {
        return fmod(floor(self / 1000), 1000)
    }
    
    private var b: Double {
        return fmod(self, 1000)
    }
    
    var isDarkColor: Bool {
        return (r * 0.2126) + (g * 0.7152) + (b * 0.0722) < 127.5
    }
    
    var isBlackOrWhite: Bool {
        return (r > 232 && g > 232 && b > 232) || (r < 23 && g < 23 && b < 23)
    }
    
    func isDistinct(_ other: Double) -> Bool {
        let c1Red = self.r
        let c1Green = self.g
        let c1Blue = self.b
        
        let c2Red = other.r
        let c2Green = other.g
        let c2Blue = other.b

        return (fabs(c1Red - c2Red) > 63.75 || fabs(c1Green - c2Green) > 63.75 || fabs(c1Blue - c2Blue) > 63.75)
            && !(fabs(c1Red - c1Green) < 7.65 && fabs(c1Red - c1Blue) < 7.65 && fabs(c2Red - c2Green) < 7.65 && fabs(c2Red - c2Blue) < 7.65)
    }
    
    func with(minSaturation: Double) -> Double {
        // Ref: https://en.wikipedia.org/wiki/HSL_and_HSV
        
        // Convert RGB to HSV
        let red = r / 255
        let green = g / 255
        let blue = b / 255
        var hue, saturation, brightness: Double
        let max = fmax(red, fmax(green, blue))
        var difference = max - fmin(red, fmin(green, blue))
        
        brightness = max
        saturation = brightness == 0 ? 0 : difference / brightness
        
        if minSaturation <= saturation {
            return self
        }
        
        if difference == 0 {
            hue = 0
        } else if red == max {
            hue = fmod((green - blue) / difference, 6)
        } else if green == max {
            hue = 2 + ((blue - red) / difference)
        } else {
            hue = 4 + ((red - green) / difference)
        }
        
        if hue < 0 {
            hue += 6
        }
        
        // Back to RGB
        
        difference = brightness * minSaturation
        let X = difference * (1 - fabs(fmod(hue, 2) - 1))
        var R, G, B: Double
        
        switch hue {
        case 0...1:
            R = difference
            G = X
            B = 0
        case 1...2:
            R = X
            G = difference
            B = 0
        case 2...3:
            R = 0
            G = difference
            B = X
        case 3...4:
            R = 0
            G = X
            B = difference
        case 4...5:
            R = X
            G = 0
            B = difference
        case 5..<6:
            R = difference
            G = 0
            B = X
        default:
            R = 0
            G = 0
            B = 0
        }
        
        let m = brightness - difference
        
        return (floor((R + m) * 255) * 1000000) + (floor((G + m) * 255) * 1000) + floor((B + m) * 255)
    }
    
    func isContrasting(_ color: Double) -> Bool {
        let bgLum = (0.2126 * r) + (0.7152 * g) + (0.0722 * b) + 12.75
        let fgLum = (0.2126 * color.r) + (0.7152 * color.g) + (0.0722 * color.b) + 12.75
        if bgLum > fgLum {
            return 1.6 < bgLum / fgLum
        } else {
            return 1.6 < fgLum / bgLum
        }
    }
    
    var uicolor: UIColor {
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
    var pretty: String {
        return "\(Int(self.r)), \(Int(self.g)), \(Int(self.b))"
    }
}

extension UIImage {
    private func resizeForUIImageColors(newSize: CGSize) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            defer {
                UIGraphicsEndImageContext()
            }
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
                fatalError("UIImageColors.resizeForUIImageColors failed: UIGraphicsGetImageFromCurrentImageContext returned nil.")
            }

            return result
    }

    public func getColors(quality: UIImageColorsQuality = .high, _ completion: @escaping (UIImageColors?) -> Void) {
        DispatchQueue.global().async {
            let result = self.getColors(quality: quality)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    public func getColors(quality: UIImageColorsQuality = .high) -> UIImageColors? {
        var scaleDownSize: CGSize = self.size
        if quality != .highest {
            if self.size.width < self.size.height {
                let ratio = self.size.height/self.size.width
                scaleDownSize = CGSize(width: quality.rawValue/ratio, height: quality.rawValue)
            } else {
                let ratio = self.size.width/self.size.height
                scaleDownSize = CGSize(width: quality.rawValue, height: quality.rawValue/ratio)
            }
        }
        
        guard let resizedImage = self.resizeForUIImageColors(newSize: scaleDownSize), let cgImage = resizedImage.cgImage else { return nil }
        
        let width: Int = cgImage.width
        let height: Int = cgImage.height
        
        let threshold = Int(CGFloat(height) * 0.01)
        var proposed: [Double] = [-1, -1, -1, -1]
        
        guard let data = CFDataGetBytePtr(cgImage.dataProvider!.data) else {
            fatalError("UIImageColors.getColors failed: could not get cgImage data.")
        }
        
        let imageColors = NSCountedSet(capacity: width * height)
        for x in 0..<width {
            for y in 0..<height {
                let pixel: Int = ((width * y) + x) * 4
                if 127 <= data[pixel + 3] {
                    imageColors.add((Double(data[pixel + 2]) * 1000000) + (Double(data[pixel + 1]) * 1000) + (Double(data[pixel])))
                }
            }
        }

        let sortedColorComparator: Comparator = { (main, other) -> ComparisonResult in
            let m = main as! UIImageColorsCounter, o = other as! UIImageColorsCounter
            if m.count < o.count {
                return .orderedDescending
            } else if m.count == o.count {
                return .orderedSame
            } else {
                return .orderedAscending
            }
        }
        
        var enumerator = imageColors.objectEnumerator()
        var sortedColors = NSMutableArray(capacity: imageColors.count)
        while let K = enumerator.nextObject() as? Double {
            let C = imageColors.count(for: K)
            if threshold < C {
                sortedColors.add(UIImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)

        var proposedEdgeColor: UIImageColorsCounter
        if 0 < sortedColors.count {
            proposedEdgeColor = sortedColors.object(at: 0) as! UIImageColorsCounter
        } else {
            proposedEdgeColor = UIImageColorsCounter(color: 0, count: 1)
        }
        
        if proposedEdgeColor.color.isBlackOrWhite && 0 < sortedColors.count {
            for i in 1..<sortedColors.count {
                let nextProposedEdgeColor = sortedColors.object(at: i) as! UIImageColorsCounter
                if Double(nextProposedEdgeColor.count) / Double(proposedEdgeColor.count) > 0.3 {
                    if !nextProposedEdgeColor.color.isBlackOrWhite {
                        proposedEdgeColor = nextProposedEdgeColor
                        break
                    }
                } else {
                    break
                }
            }
        }
        proposed[0] = proposedEdgeColor.color

        enumerator = imageColors.objectEnumerator()
        sortedColors.removeAllObjects()
        sortedColors = NSMutableArray(capacity: imageColors.count)
        let findDarkTextColor = !proposed[0].isDarkColor
        
        while var K = enumerator.nextObject() as? Double {
            K = K.with(minSaturation: 0.15)
            if K.isDarkColor == findDarkTextColor {
                let C = imageColors.count(for: K)
                sortedColors.add(UIImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        for color in sortedColors {
            let color = (color as! UIImageColorsCounter).color
            
            if proposed[1] == -1 {
                if color.isContrasting(proposed[0]) {
                    proposed[1] = color
                }
            } else if proposed[2] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[2] = color
            } else if proposed[3] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[2].isDistinct(color) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[3] = color
                break
            }
        }
        
        let isDarkBackground = proposed[0].isDarkColor
        for i in 1...3 {
            if proposed[i] == -1 {
                proposed[i] = isDarkBackground ? 255255255 : 0
            }
        }
        
        return UIImageColors(
            background: proposed[0].uicolor,
            primary: proposed[1].uicolor,
            secondary: proposed[2].uicolor,
            detail: proposed[3].uicolor
        )
    }
}
