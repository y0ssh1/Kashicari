import Foundation
import SnapKit
import UIKit

class ChoiceRentalPeriodViewController: UIViewController {
    var item: Item?
    
    class pickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        var dataList = [String]()
        
        /*
         // Only override drawRect: if you perform custom drawing.
         // An empty implementation adversely affects performance during animation.
         override func drawRect(rect: CGRect) {
         // Drawing code
         }
         */
        
        init() {
            super.init(frame: CGRect.zero)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        func setup(dataList: [String]) {
            self.dataList = dataList
            
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            picker.showsSelectionIndicator = true
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            toolbar.setItems([cancelItem, doneItem], animated: true)
    
            self.inputView = picker
            self.inputAccessoryView = toolbar
        }
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataList.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dataList[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.text = dataList[row]
        }
        
        @objc func cancel() {
            self.text = ""
            self.endEditing(true)
        }
        
        @objc func done() {
            self.endEditing(true)
        }
    }
    
    @objc func presentChoiceAlertController(){
        self.present(choiceAlertController, animated: true, completion: nil)
    }

    private lazy var choiceTextField: pickerTextField = {
        let field = pickerTextField()
        let dataList = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        field.setup(dataList: dataList)
        field.backgroundColor = .white
        field.textAlignment = NSTextAlignment.right
        field.borderStyle = UITextBorderStyle.roundedRect
        return field
    }()

    private lazy var choiceHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "何日間レンタルしますか？"
        label.font = UIFont(name: UIFont.themeFont, size: 25)
        label.textColor = .black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()

    private lazy var defaultAction: UIAlertAction = {
        let defaultAction = UIAlertAction(title: "決済して注文する",
                                          style: UIAlertActionStyle.default,
                                          handler:{(action:UIAlertAction!) -> Void in
                                            self.moveToOrderedView()})
        return defaultAction
    }()
    private lazy var cancelAction: UIAlertAction = {
        let cancelAction = UIAlertAction(title: "キャンセルする",
                                         style: UIAlertActionStyle.cancel,
                                         handler:{(action:UIAlertAction!) -> Void in
                                            self.navigationController?.popViewController(animated: true)})
        return cancelAction
    }()
    private lazy var choiceAlertController: UIAlertController = {
        let alertController = UIAlertController(title:"注文を確定しますか？",
                                                message: "返却日は11月5日です",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        return alertController
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 10
        button.setTitle("決定", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont.themeBoldFont, size: 23)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(presentChoiceAlertController), for: .touchUpInside)
        
        return button
    }()

    func moveToOrderedView() {
        let vc = OrderedViewController()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "期間選択"
        view.backgroundColor = UIColor.defaultBackGroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(choiceTextField)
        choiceTextField.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        })
        view.addSubview(choiceHeadingLabel)
        choiceHeadingLabel.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(choiceTextField.snp.top).offset(-40)
        })
        
        view.addSubview(orderButton)
        orderButton.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(choiceTextField.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalTo(150)

        })

    
    }
}



