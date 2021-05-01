//
//  ReceptViewController.swift
//  UrwayDemoApp
//

import UIKit
import Urway

protocol IReceptViewController: class {
	var router: IReceptRouter? { get set }
}

class ReceptViewController: UIViewController {
	var interactor: IReceptInteractor?
	var router: IReceptRouter?

    var model: PaymentResultData? = nil
    
    var dict: [String: String] = [:]
    
    @IBOutlet var receptTableview: UITableView!
    @IBAction func btnPress(_ sender: Any)
    {
        backAction()
    }
    
    var titles = ["Amount" , "Response" , "Transaction ID"  , "Result" , "Token Code","Card Brand","Masked PAN","Response Message"]
    
    var values: [String] = []
    
	override func viewDidLoad() {
        super.viewDidLoad()
		// do someting...
      
        self.title = "RECEIPT"

        values.append(model?.amount ?? "nil")
//      values.append(model?.paymentID ?? "nil")
        values.append(model?.responseCode ?? "nil")
        values.append(model?.transID ?? "nil")
        
        values.append(model?.result ?? "nil")
        values.append(model?.tokenID ?? "")
        values.append(model?.cardBrand ?? "")
        values.append(model?.maskedPan ?? "")
        values.append(model?.respMsg ?? "")
        
        receptTableview.register(UINib(nibName: "ReceptCell", bundle: nil), forCellReuseIdentifier: "ReceptCell")
        receptTableview.dataSource = self
        receptTableview.delegate = self
        receptTableview.reloadData()
    }
}

extension ReceptViewController: IReceptViewController {
	// do someting...
}

extension ReceptViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }			
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptCell") as! ReceptCell
        let key = titles[indexPath.row]
        let value = values[indexPath.row]
//        if( value == "nil" || value.isEmpty == true )
//        {
//            self.titles.remove(at: indexPath.row )
//            self.values.remove(at: indexPath.row )
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
        
        cell.setTitle(title: "\(key)  :  \(value)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    
 
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//
//
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.dismiss(animated: true, completion: nil)
//    }  ////this is used to close the page on click
}

extension ReceptViewController {
	// do someting...
}
