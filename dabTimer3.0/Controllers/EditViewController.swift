//
//  EditViewController.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/16/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate: class {
    func editViewControllerDidCancel(_ controller: EditViewController)
    func editViewController(_ controller: EditViewController, didFinishAdding timerListItem: TimerListItem)
    func editViewController(_ controller: EditViewController, didFinishEditing timerListItem: TimerListItem)
}


class EditViewController: UITableViewController, UITextFieldDelegate {
    

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: EditViewControllerDelegate?
    
    var timerToEdit: TimerListItem?
    
    override func viewDidLoad() {
        
        if let timerToEdit = timerToEdit {
            title = "Edit Timer Name"
            textField.text = timerToEdit.name
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
        delegate?.editViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let timerListItem = timerToEdit {
            timerListItem.name = textField.text!
            delegate?.editViewController(self, didFinishEditing: timerListItem)
        } else {
            let timerListItem = TimerListItem(name: textField.text!)
            delegate?.editViewController(self, didFinishAdding: timerListItem)
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
