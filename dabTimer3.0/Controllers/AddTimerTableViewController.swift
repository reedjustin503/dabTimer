//
//  addItemTableViewController.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/15/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import UIKit

protocol AddTimerTableViewControllerDelegate: class {
    
    func addTimerTableViewControllerDidCancel(_ controller: AddTimerTableViewController)
    func addTimerTableViewController(_ controller: AddTimerTableViewController, didFinishAdding item: UpDownTimer)
    
}


class AddTimerTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK:- Outlets
    weak var delegate: AddTimerTableViewControllerDelegate?
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textFieldUpTimer: UITextField!
    @IBOutlet weak var textFieldDownTimer: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldName.becomeFirstResponder()
    }

    
    //MARK:- Actions

    @IBAction func pressedCancel(_ sender: Any) {
        delegate?.addTimerTableViewControllerDidCancel(self)
    }
    
   


    @IBAction func pressedDone(_ sender: Any) {
        
        let upDownTimer = UpDownTimer()
        upDownTimer.name = textFieldName.text!
        upDownTimer.heatUpTimer = Int(textFieldUpTimer.text!)!
        upDownTimer.coolDownTimer = Int(textFieldDownTimer.text!)!
        
        delegate?.addTimerTableViewController(self, didFinishAdding: upDownTimer )
        
    }

    
    
    //MARK:- TableView Methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Custom Functions
    func textField(_ TtextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textFieldName.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
}
