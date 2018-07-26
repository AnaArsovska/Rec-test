//
//  AddRecViewController.swift
//  Recky
//
//  Created by Samina Abdullah on 7/23/18.
//  Copyright © 2018 Samina Abdullah. All rights reserved.
//

import UIKit
import CoreData

class AddRecViewController: UIViewController {

    // MARK: Properties
    
    var managedContext: NSManagedObjectContext!
    var rec: Recommendation?
    
    // MARK: Outlets
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        
        nameText.becomeFirstResponder()
        
        if let rec = rec {
            nameText.text = rec.name
            nameText.text = rec.name
            locationText.text = rec.location
            locationText.text = rec.location
        }
        
    }

    // MARK: Actions

    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}

        let keyboardHeight = keyboardFrame.cgRectValue.height + 16

        bottomConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        nameText.resignFirstResponder()
    }

    @IBAction func done(_ sender: Any) {
        guard let title = nameText.text, !title.isEmpty else{
            return
        }
        guard let address = locationText.text, !address.isEmpty else{
            return
        }
        
        if let rec = self.rec{
            rec.name = title
            rec.location = address

        } else{
            
            let rec = Recommendation(context: managedContext)
            rec.name = title
            rec.location = address
            rec.date = Date()
            
        }
        
        do{
            try managedContext.save()
            dismiss(animated: true)
        } catch{
            print("Error saving recommendation: \(error)")
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddRecViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ name: UITextView) {
        if doneButton.isHidden{
            name.text.removeAll()
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidBeginEditing(_ location: UITextView) {
        location.text.removeAll()
        doneButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
