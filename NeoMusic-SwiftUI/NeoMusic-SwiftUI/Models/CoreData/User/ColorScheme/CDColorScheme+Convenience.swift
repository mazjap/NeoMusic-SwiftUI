import CoreData

extension CDColorScheme {
    convenience init(_ scheme: JCColorScheme, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.gradients = [
            CDEasyGradient(scheme.backgroundGradient, context: context),
            CDEasyGradient(scheme.sliderGradient, context: context)
        ]
        
        self.colors = [
            CDEasyColor(scheme.textColor, context: context),
            CDEasyColor(scheme.mainButtonColor, context: context),
            CDEasyColor(scheme.secondaryButtonColor, context: context)
        ]
        
        self.dateAdded = scheme.dateAdded
        self.name = scheme.name ?? "Saved"
    }
    
    public var id: String {
        "\(String(describing: gradients?[0])),\(String(describing: gradients?[1])),\(String(describing: colors?[0])),\(String(describing: colors?[1])),\(String(describing: colors?[2]))"
    }
    
    public override var description: String {
        id
    }
    
    var jc: JCColorScheme? {
        if let gradients = gradients?.array as? [CDEasyGradient], let colors = colors?.array as? [CDEasyColor] {
            return JCColorScheme(backgroundGradient: gradients[0].easy, sliderGradient: gradients[1].easy, textColor: colors[0].easy, mainButtonColor: colors[1].easy, secondaryButtonColor: colors[2].easy)
        }
        
        return nil
    }
    
    static func == (lhs: CDColorScheme, rhs: JCColorScheme) -> Bool {
        return lhs.id == rhs.id
    }
}
