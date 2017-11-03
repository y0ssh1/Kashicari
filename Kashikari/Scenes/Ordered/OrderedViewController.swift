import Foundation
import SnapKit
import UIKit

class OrderedViewController: UIViewController {
    var item: Item?

    private lazy var passwordStackView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .white
        return stackView
    }()

    private lazy var passwordHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "レンタル注文が完了しました！\nパスワードは以下です。"
        label.font = UIFont(name: UIFont.themeFont, size: 25)
        label.textColor = .black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()

    private lazy var passwordValueLabel: UILabel = {
        let label = UILabel()
        label.text = "jphacks17"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 25)
        label.textColor = .black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注文完了"
        view.backgroundColor = UIColor.defaultBackGroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(passwordStackView)
        passwordStackView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.width.equalToSuperview()
            make.height.equalTo(110)
        })
        
        passwordStackView.addSubview(passwordHeadingLabel)
        passwordHeadingLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(15)
        })

        passwordStackView.addSubview(passwordValueLabel)
        passwordValueLabel.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordHeadingLabel.snp.bottom).offset(15)
        })
        
    }
}


