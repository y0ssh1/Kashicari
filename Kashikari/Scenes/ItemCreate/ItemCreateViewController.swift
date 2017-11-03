import Foundation
import UIKit

class ItemCreateViewController: UIViewController {
    var items: [Item] = [] {
        didSet {
            currentItem = items.first
        }
    }
    private var currentItem: Item?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.backgroundColor = UIColor.defaultBackGroundColor
        return scroll
    }()
    
    private lazy var itemNameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "商品名: (例)サーフボード"
        field.delegate = self
        return field
    }()
    
    private lazy var descriptionField: UITextView = {
       let view = UITextView()
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    private lazy var itemPriceField: UITextField = {
       let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "値段"
        field.delegate = self
        field.keyboardType = .numberPad
        return field
    }()
    
    private lazy var itemImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.defaultBackGroundColor.cgColor
        return imageView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        button.layer.cornerRadius = 5
        button.setTitle("決定", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont.themeBoldFont, size: 20)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
        return button
    }()
    
    private lazy var itemNameLabel: UILabel = {
       let label = UILabel()
        label.text = "商品名"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 13)
        return label
    }()
    
    private lazy var itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "商品説明"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 13)
        return label
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "値段"
        label.font = UIFont(name: UIFont.themeBoldFont, size: 13)
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.backgroundColor = UIColor.translucentBlack
        indicator.layer.cornerRadius = 5
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @objc func moveToNextView() {
        guard let item = currentItem else { return }
        item.name = itemNameField.text ?? ""
        item.price = Int(itemPriceField.text ?? "0") ?? 0
        item.description = itemDescriptionLabel.text ?? ""
        
//        let vc = MainViewController()
//        DispatchQueue.main.async { [weak self] in
//            self?.navigationController?.setViewControllers([vc], animated: true)
//        }
//        return
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        indicator.startAnimating()
        Service.items.post(name: item.name,
                           description: item.description,
                           imageUrl: item.imgUrl,
                           price: item.price,
                           completion: { [weak self] in
                                DispatchQueue.main.async {
                                    self?.indicator.stopAnimating()
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                }
                                self?.items.remove(at: 0)
                                guard let strongSelf = self, !strongSelf.items.isEmpty else {
                                    let vc = MainViewController()
                                    DispatchQueue.main.async {
                                        self?.navigationController?.setViewControllers([vc], animated: true)
                                    }
                                    return
                                }
                                let vc = ItemCreateViewController()
                                vc.items = strongSelf.items
                                DispatchQueue.main.async {
                                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                                }
                            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.defaultBackGroundColor
        if let item = currentItem {
            setupViews(item: item)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func setupViews(item: Item) {
        view.backgroundColor = UIColor.white
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({(make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.greaterThanOrEqualTo(view.frame.height + 200)
        })
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        })
        
        if let url = URL(string: item.imgUrl) {
            itemImageView.af_setImage(withURL: url)
        }
        contentView.addSubview(itemImageView)
        itemImageView.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(400)
        })
        
        contentView.addSubview(itemNameLabel)
        itemNameLabel.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemImageView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(15)
        })
        
        contentView.addSubview(itemNameField)
        itemNameField.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        })
        
        contentView.addSubview(itemPriceLabel)
        itemPriceLabel.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemNameField.snp.bottom).offset(30)
            make.left.equalTo(itemNameField.snp.left)
        })
        
        contentView.addSubview(itemPriceField)
        itemPriceField.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemPriceLabel.snp.bottom).offset(10)
            make.left.equalTo(itemNameField.snp.left)
        })
        
        
        contentView.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemPriceField.snp.bottom).offset(30)
            make.left.equalTo(itemNameField.snp.left)
        })
        
        contentView.addSubview(descriptionField)
        descriptionField.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(itemDescriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(itemNameField.snp.left)
            make.right.equalTo(itemNameField.snp.right)
            make.height.equalTo(50)
        })
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionField.snp.bottom).offset(100)
            make.width.equalTo(100)
            make.height.equalTo(40)
        })
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints({ (make) -> Void in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        view.bringSubview(toFront: indicator)
    }
}

extension ItemCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == itemPriceField else { return true }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

extension ItemCreateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        textView.resignFirstResponder()
        return false
    }
}

