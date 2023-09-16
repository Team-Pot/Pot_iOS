import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    let color1: CGColor = UIColor(red: 209/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 134/255, green: 168/255, blue: 231/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 95/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
    
    let gradientLayerForButton : CAGradientLayer = CAGradientLayer()
        
    
    private lazy var nextPageButton = CustomButton(
        title: "로그인",
        backgroundColor: .gray,
        titleColor: .white,
        font: UIFont.systemFont(ofSize: 16, weight: .semibold)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nextPageButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupGradient()
        animateGradient()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
    
    func setupGradient(){
        
        gradientColorSet = [
            [color1, color2],
            [color2, color3],
            [color3, color1]
        ]
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientColorSet[colorIndex]
        
        self.view.layer.addSublayer(gradient)
        
        gradientLayerForButton.frame.size.width =
        self.nextPageButton.frame.size.width
        gradientLayerForButton.frame.size.height =
        self.nextPageButton.frame.size.height
        self.nextPageButton.layer.insertSublayer(gradientLayerForButton,
                                                 at:uint(0))
    }
    
    func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 3.0
        
        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradient.add(gradientAnimation, forKey: "colors")
    }
    
    func updateColorIndex(){
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
}
