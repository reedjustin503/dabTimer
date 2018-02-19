//
//  AddTimerViewController.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/17/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import UIKit

protocol AddTimerViewControllerDelegate: class {
    func addTimerViewControllerDelegateDidCancel(_ controller: AddTimerViewController)
    func addTimerViewController(_ controller: AddTimerViewController, didFinishAdding timerListItem: UpDownTimer)
    func addTimerViewController(_ controller: AddTimerViewController, didFinishEditing timerListItem: UpDownTimer)
}

class AddTimerViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddTimerViewControllerDelegate?
    var upDownTimerToEdit: UpDownTimer?
  
    
    
    
    override func viewDidLoad() {
        
        if let upDownTimerToEdit = upDownTimerToEdit {
            title = "Edit Timer Name"
            textField.text = upDownTimerToEdit.name
            doneBarButton.isEnabled = true
        } else {
            title = "Name Timer"
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addTimerViewControllerDelegateDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        
        if let timer = upDownTimerToEdit {
            timer.name = textField.text!
            delegate?.addTimerViewController(self, didFinishEditing: timer)
        } else {
            let timer = UpDownTimer()
            timer.name = textField.text!
            delegate?.addTimerViewController(self, didFinishAdding: timer)
        }
        
        
    }
    
    // MARK:- TableView Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK:- UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
        
    }
    
}
