import Foundation
import SnapKit
import UIKit

class ItemShowViewController: UIViewController {
    var item: Item?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.backgroundColor = UIColor.defaultBackGroundColor
        return scroll
    }()

    private lazy var itemImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.defaultBackGroundColor.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()

    private lazy var userHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "出品者"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 15)
        label.textColor = UIColor.themeColor
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        return label
    }()

    private lazy var userStackView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .white
        return stackView
    }()

    private lazy var userImageView: UIImageView = {
        let image: UIImage = UIImage(named: "konkon")!
        let imageView: UIImageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CGFloat(25.0)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "よしの　かつき"
        label.numberOfLines = 1
        label.font = UIFont(name: UIFont.themeBoldFont, size: 15)
        label.textColor = .black
        return label
    }()

    private lazy var userScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "高評価:112 低評価:25"
        label.numberOfLines = 1
        label.font = UIFont(name: UIFont.themeFont, size: 15)
        label.textColor = .black
        return label
    }()

    private lazy var productStackView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .white
        return stackView
    }()

    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: UIFont.themeBoldFont, size: 18)
        return label
    }()

    private lazy var productLikeImageView: UIImageView = {
        let image: UIImage = UIImage(named: "like")!
        let imageView: UIImageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var descriptionHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "商品の説明"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 15)
        label.textColor = UIColor.themeColor
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionStackView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .white
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: UIFont.themeFont, size: 14)
        label.textColor = .black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()

    private lazy var footerView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = UIColor.translucentBlack
        return stackView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: UIFont.themeBoldFont, size: 18)
        label.textColor = .white
        return label
    }()

    private lazy var exhibitButton: UIButton = {
        let button = UIButton()
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 5
        button.setTitle("レンタルする", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont.themeBoldFont, size: 15)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(moveToChoiceRentalPeriodView), for: .touchUpInside)

        return button
    }()
    
    @objc func moveToChoiceRentalPeriodView() {
        let vc = ChoiceRentalPeriodViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = item?.name
        view.backgroundColor = UIColor.defaultBackGroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        setupViews()
    }

    private func setupViews() {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({(make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.greaterThanOrEqualTo(view.frame.height)
        })
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        })
        contentView.addSubview(itemImageView)
        
        guard let item = item else { return }
        if let url = URL(string: item.imgUrl) {
            itemImageView.af_setImage(withURL: url)
        }

        itemImageView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(300)
        })

        contentView.addSubview(productStackView)
        productStackView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(itemImageView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        })

        productNameLabel.text = item.name
        productStackView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        })

        productStackView.addSubview(productLikeImageView)
        productLikeImageView.snp.makeConstraints({ (make) -> Void in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        })

        contentView.addSubview(descriptionHeadingLabel)
        descriptionHeadingLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(productStackView.snp.bottom).offset(10)
        })

        contentView.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(descriptionHeadingLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
        })

        descriptionLabel.text = item.description
        descriptionStackView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        })

        descriptionStackView.snp.makeConstraints({ (make) -> Void in
            make.height.equalTo(descriptionLabel.snp.height).offset(20)
        })

        contentView.addSubview(userHeadingLabel)
        userHeadingLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descriptionStackView.snp.bottom).offset(10)
        })

        contentView.addSubview(userStackView)
        userStackView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalTo(userHeadingLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        })

        userStackView.addSubview(userImageView)
        userImageView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(45)
        })

        userStackView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.centerY.equalTo(userImageView)
        })

        userStackView.addSubview(userScoreLabel)
        userScoreLabel.snp.makeConstraints({(make) -> Void in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(userImageView)
        })

        view.addSubview(footerView)
        footerView.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        })

        priceLabel.text = "¥" + String(item.price)
        footerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        })

        footerView.addSubview(exhibitButton)
        exhibitButton.snp.makeConstraints({ (make) -> Void in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(140)
        })
    }
}
