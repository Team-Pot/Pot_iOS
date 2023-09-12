import UIKit
import SnapKit
import Then

class LoginViewController: BaseVC {
    
    private let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 20) as Any
    ]
    
    private var potTextLogo = UIImageView().then {
        $0.image = UIImage(named: "PotTextLogo")
    }
    
    var potInfoText = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.text = "안녕하세요.\nPOT입니다."
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
    }
    
    public lazy var textFields: [CustomTextField] = {
        let idTextField = CustomTextField()
        idTextField.placeholder = "아이디"
        let pwTextField = CustomTextField()
        pwTextField.isSecureTextEntry = true
        pwTextField.placeholder = "비밀번호"
        return [idTextField, pwTextField]
    }()
    
    private lazy var lines: [UIView] = {
        let line1 = createLineView()
        let line2 = createLineView()
        return [line1, line2]
    }()

    
    private lazy var nextPageButton = CustomButton(
        title: "로그인",
        backgroundColor: .gray,
        titleColor: .white,
        font: UIFont.systemFont(ofSize: 16, weight: .semibold)
    ).then {
        $0.addTarget(self, action: #selector(nextPageButtonDidTap), for: .touchUpInside)
    }
    
    override func layout() {
        textFields.forEach { view.addSubview($0) }
        lines.forEach { view.addSubview($0) }
        [
            potTextLogo,
            potInfoText,
            nextPageButton,
        ].forEach { view.addSubview($0) }
        
        potTextLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(34.68)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26.49)
            $0.width.equalTo(110.23)
            $0.height.equalTo(72.57)
        }
        
        potInfoText.snp.makeConstraints {
            $0.top.equalTo(potTextLogo.snp.bottom).offset(26.69)
            $0.height.equalTo(62)
            $0.leading.equalToSuperview().offset(34.29)
        }
        
        for i in 0..<textFields.count {
            textFields[i].snp.makeConstraints() {
                if i == 0 {
                    $0.top.equalTo(potInfoText.snp.bottom).offset(59.25)
                } else {
                    $0.top.equalTo(textFields[i - 1].snp.bottom).offset(24)
                }
                $0.left.equalToSuperview().offset(20)
                $0.width.equalToSuperview()
                $0.height.equalTo(56)
            }
            
            lines[i].snp.makeConstraints() {
                $0.top.equalTo(textFields[i].snp.bottom).offset(0)
                $0.left.equalToSuperview().offset(20)
                $0.right.equalToSuperview().inset(20)
                $0.height.equalTo(2)
            }
            
            nextPageButton.snp.makeConstraints {
                $0.top.equalTo(textFields[1].snp.bottom).offset(150.0)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(338.0)
                $0.height.equalTo(54.0)
            }
        }
    }
    
    override func attribute() {
        super.attribute()
        textFields.enumerated().forEach { index, textField in
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                                 attributes: attributes)
            textField.delegate = self
            textField.tag = index + 1
            textField.textColor = .white
            textField.addTarget(self, action: #selector(textFieldContentDidChange(_:)), for: .editingChanged)
        }
        
        setupKeyboardObservers()

    }
    
    @objc private func textFieldContentDidChange(_ textField: UITextField) {
        updateButtonColor()
    }
    
    private func createLineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = .white
        return lineView
    }
    
    private func createTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.tintColor = .white
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.placeholder = placeholder
        return textField
    }
    
    private func updateButtonColor() {
        DispatchQueue.main.async {
                if let text1 = self.textFields[0].text, !text1.isEmpty,
                   let text2 = self.textFields[1].text, !text2.isEmpty {
                    self.nextPageButton.backgroundColor = .systemPink
                } else {
                    self.nextPageButton.backgroundColor = .gray
                }
            }
    }
        
    
//    @objc private func textFieldContentDidChange(_ textField: UITextField) {
//        updateButtonColor()
//    }
    
    private func animate(line: UIView) {
        line.alpha = 0.3
        UIView.animate(withDuration: 1) {
            line.alpha = 1
        }
    }
    
    
    @objc private func nextPageButtonDidTap() {
        guard let accountId = textFields[0].text, let password = textFields[1].text else {
            print("Please enter Account ID and Password.")
            return
        }
        
        //            self.navigationController?.pushViewController(TapBarV(), animated: true)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        lines.forEach { $0.backgroundColor = .purple }
    }
    
    deinit {
        removeKeyboardObservers()
    }
}
    
    
    extension LoginViewController: UITextFieldDelegate {
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            
            switch textField {
            case textFields[0]:
                animate(line: lines[0])
                lines[0].backgroundColor = .purple
            case textFields[1]:
                animate(line: lines[1])
                lines[1].backgroundColor = .purple
            default:
                return
            }
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let index = textFields.firstIndex(of: textField as! CustomTextField) {
                if index < textFields.count - 1 {
                    textFields[index + 1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
            return true
        }
        
        private func setupKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        private func removeKeyboardObservers() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                
                UIView.animate(withDuration: 0.3) {
                    self.nextPageButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 200)
                }
            }
        }
        
        @objc private func keyboardWillHide(notification: NSNotification) {
            UIView.animate(withDuration: 0.3) {
                self.nextPageButton.transform = .identity
            }
        }
    }
    
extension CustomTextField {
    public func isIncorrectIdPW() -> Bool {
        setMessage("아이디나 비밀번호가 맞지 않습니다.", color: .systemRed)
        return false
    }
        
    public func isCorrectIdPW() -> Bool {
        setMessage(nil)
        return true
    }
}
