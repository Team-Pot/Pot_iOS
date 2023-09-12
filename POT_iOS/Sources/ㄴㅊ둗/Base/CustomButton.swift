import UIKit

open class CustomButton: UIButton {
    
    public init(
        title: String,
        backgroundColor: UIColor,
        titleColor: UIColor,
        font: UIFont? = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
    ) {
        let frame = CGRect(x: 0, y: 0, width: 338, height: 54)
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        
        layer.cornerRadius = 10
        
        setTitle(title, for: .normal)
        titleLabel?.font = font
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

