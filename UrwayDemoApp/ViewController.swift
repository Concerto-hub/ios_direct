//
//  ViewController.swift
//  UrwayDemoApp
//
//

import UIKit
import Urway
import SwiftyMenu
import SnapKit
import PassKit
import iOSDropDown

class ViewController: UIViewController , UIScrollViewDelegate, UITextFieldDelegate
{

    
    @IBOutlet var amountField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var currencyField: UITextField!
    @IBOutlet var countryField: UITextField!
    //@IBOutlet var actionField: UITextField!
    
    @IBOutlet var transId: UITextField!
    @IBOutlet weak var actionDropDown: DropDown!
    
    @IBOutlet var trackIDField: UITextField!
    
    @IBOutlet var utf1: UITextField!
    @IBOutlet var utf2: UITextField!
    @IBOutlet var utf3: UITextField!
    @IBOutlet var utf4: UITextField!
    @IBOutlet var utf5: UITextField!
    
    @IBOutlet weak var cardOperdropDwn: DropDown!
//    @IBOutlet var merchantField: UITextField!
    @IBOutlet var tockenField: UITextField!
//  @IBOutlet var picker: UIPickerView!
    
    @IBOutlet var stateField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var holderField: UITextField!

    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var holderStakView: UIStackView!
    
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var topsegmentController: UISegmentedControl!
    
    @IBOutlet var merchantIdentifier: UITextField!
//  @IBOutlet var topHolderStack: UIStackView!
    
    @IBOutlet var cardnumber: UITextField!
    @IBOutlet var expmonth: UITextField!
    @IBOutlet var cvv: SDCTextField!
    @IBOutlet var expyear: UITextField!
    @IBOutlet var cardholdername: UITextField!
    
    var addressHeightAnchor: NSLayoutConstraint? = nil
    var stateHeightAnchor: NSLayoutConstraint? = nil
    var cityHeightAnchor: NSLayoutConstraint? = nil
    var countryHeightAnchor: NSLayoutConstraint? = nil
    var cardTokenHeightAnchor:NSLayoutConstraint? = nil
    var merchantIdentifierHeightAnchor:NSLayoutConstraint? = nil
    
    let pickerData = ["Select Card Operation","Add" , "Update" , "Delete"]
    var selectedText = "Add"
    var isTokenEnabled: Bool = true
    var paymentController: UIViewController? = nil
    
    var paymentString: NSString = ""
    var actionCodeId = " "
    var cardOperation = " "
    var isApplePayPaymentTrxn:Bool = false;
    
//    @IBOutlet private weak var dropDown: SwiftyMenu!
//   @IBOutlet private weak var otherView: UIView!
//   let dropDownOptionsDataSource = ["Option 1", "Option 1", "Option 1", "Option 1", "Option 1", "Option 1", "Option 1", "Option 1", "Option 1"]
//  let color = ["blue","brown","clear","cyan","gray","green","lightGray","orange","purple","red","white","yellow","black"]

//    var paymentRequest : PKPaymentRequest = {
//    let request = PKPaymentRequest()
//    request.merchantIdentifier = "merchant.testios.com"
//        request.supportedNetworks = [.quicPay, .masterCard, .visa , .amex , .discover , .mada ]
//        request.merchantCapabilities = .capability3DS
//        request.countryCode = "SA"
//        request.currencyCode = "SAR"
//        request.countryCode = countryField.text ?? ""
//        request.currencyCode = currencyField.text ?? ""
//        return request
//     }()
    
    var isSucessStatus: Bool = false
    
    
    var originalSize: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
              
        self.title = "DEMO"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.backgroundColor = .white
        self.scrollview.showsVerticalScrollIndicator = false
        self.scrollview.delegate = self
        
        self.originalSize = self.tockenField.frame.height
        self.merchantIdentifier.isHidden=true
        
//        self.cvv.delegate = self
//        self.cvv.maxLength = 3
        
        actionDropDown.optionArray=["Select Action","Purchase","Pre Auth ","Capture ","Refund ","Void Refund","Void Purchase ", "Void Pre Auth","Tokenization ","STC Pay"]
       actionDropDown.optionIds = [0,1,4,5,2,6,3,9,12,13]
      
        actionDropDown.didSelect{(selectedText , index ,id) in
            self.actionCodeId=String(id)
//            if self.actionCodeId == "12"
//            {
////              self.isTokenEnabled=true
//                self.enableTokenFields()
//                print("Tokeization enable")
//            }
//            else
            if (self.actionCodeId == "5" || self.actionCodeId == "2" || self.actionCodeId == "6" || self.actionCodeId == "3" || self.actionCodeId == "9")
            {
//              self.isTokenEnabled=false
                self.disablerelativeTransn()
                print("Relative disable")
            }
            else if (self.actionCodeId == "1" || self.actionCodeId == "4" || self.actionCodeId == "12") 

            {
                self.enablerelativeTransnData()
            }
        //self.actionField.text = "Selected String: \(selectedText) \n index: \(id)"
        }
        
      
        
        cardOperdropDwn.optionArray=pickerData
        cardOperdropDwn.didSelect{(selectedText , index ,id) in
//            if self.isTokenEnabled
//            {
//                print("Tokeization enable1")
//                self.enableTokenFieldsAction()
//            }
//            else
//            {
//                print("Tokeization disable2")
//                self.disableTockenFields()
//            }
            
            switch index{
            case 0:
                self.cardOperation = "0"
            case 1:
                self.cardOperation = "A"
            case 2:
                self.cardOperation = "U"
            case 3:
                self.cardOperation = "D"
            default:
                break
            }
            
            print(self.cardOperation)
        }
        
       

        
        prepareConstraints()
        enableTokenFields()
        
        segmentController.setTitle("Present", forSegmentAt: 0)
        segmentController.setTitle("Not Present", forSegmentAt: 1)
        
        
        topsegmentController.setTitle("Normal Pay", forSegmentAt: 0)
        topsegmentController.setTitle("Apple Pay", forSegmentAt: 1)
        
        

        
        if  UIScreen.main.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
        }
        else
        {
            self.view.backgroundColor = .black
        }
       
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//           // if keyboard size is not available for some reason, dont do anything
//           return
//        }
//
//      // move the root view up by the distance of keyboard height
//      self.view.frame.origin.y = 0 - keyboardSize.height
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//      // move back the root view origin to zero
//      self.view.frame.origin.y = 0
//    }
//
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @IBAction func indexChanged(_ sender: Any) {
       let index =  topsegmentController.selectedSegmentIndex
        UIView.animate(withDuration: 0.3) {
//            self.topHolderStack.alpha = (index == 1) ? 0 : 1
//            self.topHolderStack.isHidden = index == 1
            
            if index == 0
            {
                print(index)
                self.merchantIdentifier.isHidden=true
            }
            else
            {
                self.merchantIdentifier.isHidden=false
               // self.disableTokenFieldsAction()
            }
            
            self.view.layoutIfNeeded()
            
        }

        self.isTokenEnabled = index == 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    

    override func viewWillAppear(_ animated: Bool) {
//        [amountField , emailField , zipField , currencyField , countryField ,tockenField , utf1 , utf2 , utf3 , utf4 , utf5 , stateField , cityField, addressField].forEach({$0?.text = ""})
        
        if  UIScreen.main.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
    @IBAction func urWayTapped() {        
       let isApplePayPayment = topsegmentController.selectedSegmentIndex == 1
        
        print("In Payment Button ")
        if isApplePayPayment {
            print("In Payment Button1 ")
           
            self.isApplePayPaymentTrxn=true;
            self.applePaymentconfigureSDK()
            self.applePayButtonAction()
            
        } else {
            self.merchantIdentifierHeightAnchor?.constant = 0
            print("In Payment Button 2")
            self.isApplePayPaymentTrxn=false;
            self.normalPaymentconfigureSDK()
            self.initializeSDK()
           
        }
        
    }
    
    
    fileprivate func initializeSDK() {
        UWInitialization(self) { (controller , result) in
            self.paymentController = controller
            guard let nonNilController = self.paymentController else {
                self.presentAlert(resut: result)
                return
            }
        
            self.navigationController?.pushViewController(nonNilController, animated: true)
        }

    }
    
    func applePaymentconfigureSDK() {
        let terminalId = "IosPay"
        let password = "password"
        let merchantKey = "96f0a1bd28450c130552bc38d8cb507655ca66d92ea7f558b37d4322c8802b39"
        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
     
        UWConfiguration(password: password, merchantKey: merchantKey, terminalID: terminalId , url: url )
    }
    
    
    func normalPaymentconfigureSDK() {
        let terminalId = "DirectR"
        let password = "password"
        let merchantKey = "4e5b624f798b6f8fa39dd0125ec1f37d3b33b473cdba6bbf03c99f3554caa32d"
        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
     
        UWConfiguration(password: password , merchantKey: merchantKey , terminalID: terminalId , url: url )
    }
    
    fileprivate func applePayButtonAction()
    {
        UWInitialization(self)
        {
            (controller , result) in
            self.paymentController = controller
            guard let _ = self.paymentController
            else {
                self.presentAlert(resut: result)
                return
            }
        }
    
        isSucessStatus = false
        let floatAmount = Double(amountField.text ?? "0") ?? .zero

            let request = PKPaymentRequest()
            request.merchantIdentifier = merchantIdentifier.text ?? ""
            request.supportedNetworks = [.quicPay, .masterCard, .visa , .amex , .discover , .mada ]
            request.merchantCapabilities = .capability3DS

            request.countryCode = countryField.text ?? ""
        request.currencyCode = currencyField.text?.trimmingCharacters(in: .whitespaces) ?? ""

            request.paymentSummaryItems = [PKPaymentSummaryItem(label: " Test ",amount: NSDecimalNumber(floatLiteral: floatAmount) )]
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        if controller != nil
        {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
}


//MARK: - APPLE PAYMENT CODE
extension ViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        isSucessStatus ? self.initializeSDK() : nil
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.paymentString = UWInitializer.generatePaymentKey(payment: payment)
        isSucessStatus = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}


extension ViewController {
    
    fileprivate func prepareConstraints() {
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: (self.holderStakView.frame.height  + 100))
//      self.picker.translatesAutoresizingMaskIntoConstraints = false
//      self.picker.dataSource = self
//      self.picker.delegate = self
//      self.pickerHeightAnchor = picker.heightAnchor.constraint(equalToConstant: 0)
        self.cardTokenHeightAnchor = tockenField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.stateHeightAnchor = stateField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.cityHeightAnchor = cityField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.countryHeightAnchor = countryField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.addressHeightAnchor = addressField.heightAnchor.constraint(equalToConstant: self.originalSize)

//        self.pickerHeightAnchor?.isActive = true
        self.cardTokenHeightAnchor?.isActive = true
        self.stateHeightAnchor?.isActive = true
        self.cityHeightAnchor?.isActive = true
        self.countryHeightAnchor?.isActive = true
        self.addressHeightAnchor?.isActive = true
        self.view.layoutIfNeeded()
    }
    
    @IBAction func switchOnePressed(_ sender: UISwitch) {
        if sender.isOn
        {
            isTokenEnabled = true
            enableTokenFields()
        }
        else
        {
            isTokenEnabled = false
         //   disableTokenFieldsAction()
        }
    }

    
//    func disableTokenFieldsAction() {
//        print("enabl")
//
//
//        self.cityHeightAnchor?.constant = 0
//        self.addressHeightAnchor?.constant = 0
//        self.stateHeightAnchor?.constant = 0
//
//        self.cityField.text = ""
//        self.countryField.text = ""
//        self.addressField.text = ""
//        self.stateField.text = ""
//        self.tockenField.text = ""
//
//      //  self.cardTokenHeightAnchor?.constant = 0
//
//        UIView.animate(withDuration: 0.5)
//        {
//            self.view.layoutIfNeeded()
//        }
//   }
    func disablerelativeTransn()
    {
        self.cardnumber.isHidden=true
        self.cvv.isHidden=true
        self.expmonth.isHidden=true
        self.expyear.isHidden=true
        self.addressField.isHidden=true
        self.cityField.isHidden=true
        self.zipField.isHidden=true
        self.stateField.isHidden=true
        self.cardholdername.isHidden=true
    }
    func enablerelativeTransnData()
    {
        self.cardnumber.isHidden=false
        self.cvv.isHidden=false
        self.expmonth.isHidden=false
        self.expyear.isHidden=false
        self.addressField.isHidden=false
        self.cityField.isHidden=false
        self.zipField.isHidden=false
        self.stateField.isHidden=false
        self.cardholdername.isHidden=false
    }
    
    func enableTokenFields()
    {
        self.cardnumber.isHidden=false
        self.cvv.isHidden=false
        self.expmonth.isHidden=false
        self.expyear.isHidden=false
//        self.addressField.isHidden=true
//        self.cityField.isHidden=true
//        self.zipField.isHidden=true
//        self.stateField.isHidden=true
    }
}


extension ViewController: Initializer {

  func prepareModel() -> UWInitializer {
   
    var udff5=utf5.text
        let model = UWInitializer.init(amount: amountField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ?? "",
                                       email: emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       zipCode: zipField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       currency: currencyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       country: countryField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" ,
                                       actionCode: actionCodeId,
                                       trackIdCode: trackIDField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ?? "",
                                       udf1:utf1.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       udf2:utf2.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       udf3:utf3.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       udf4: isApplePayPaymentTrxn ? "ApplePay" : utf4.text?.trimmingCharacters(in: .whitespacesAndNewlines) ,
                                       udf5:  isApplePayPaymentTrxn ? paymentString : udff5 as NSString? ,
                                       address: addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ,
                                       createTokenIsEnabled: isTokenEnabled,
                                       cardToken: tockenField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ,
                                       cardOper: self.cardOperation ,
                                       state: stateField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ,
                                       transid: transId.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       merchantidentifier: merchantIdentifier.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       tokenizationType: "\(segmentController.selectedSegmentIndex)",
                                       cardNumber: cardnumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       cvv: cvv.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       expMonth: expmonth.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       expYear: expyear.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                       holderName: cardholdername.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        )

        return model
    }

    func didPaymentResult(result: paymentResult, error: Error?, model: PaymentResultData?) {
        switch result {
        case .sucess:
            print("PAYMENT SUCESS")
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
        case.failure:
            
            print("PAYMENT FAILURE")
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
          
        case .mandatory(let fieldName):
            print(fieldName)
            break
        }
    }
    
    func navigateTOReceptPage(model: PaymentResultData?) {
        self.paymentController?.navigationController?.popViewController(animated: true)
        print("Navigate to receipt")
        let controller = ReceptConfiguration.setup()
        controller.model = model
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
        
       
     
       
    }
    
}
//extension ViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        // Verify all the conditions
//        if let sdcTextField = textField as? SDCTextField {
//            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
//        }
//    }
//}
extension ViewController {
    func presentAlert(resut: paymentResult) {
          var displayTitle: String = ""
          var key: mandatoryEnum = .amount

          switch resut {
          case .mandatory(let fields):
              key = fields
          default:
              break
          }
          
          switch  key {
          case .amount:
              displayTitle = "Amount"
          case.country:
              displayTitle = "Country"
          case.action_code:
              displayTitle = "Action Code"
          case.currency:
              displayTitle = "Currency"
          case.email:
              displayTitle = "Email"
          case.trackId:
              displayTitle = "TrackID"
          case .tokenID:
            displayTitle = "TokenID"
          case .cardOperation:
            displayTitle = "Token Operation"
         case .transId:
            displayTitle = "Transaction ID"
        }
          
          let alert = UIAlertController(title: "Alert", message: "Check \(displayTitle) Field", preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
     
}

