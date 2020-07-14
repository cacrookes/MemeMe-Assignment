//
//  ViewController.swift
//  MemeMe Assignment
//
//  Created by Christopher Crookes on 2020-07-13.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - Global variables
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -4.0
    ]
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        setTextFieldDefaultAttributes(for: topTextField, defaultText: "TOP")
        setTextFieldDefaultAttributes(for: bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Actions
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        presentImagePicker(using: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentImagePicker(using: .camera)
    }
    
    // MARK: - Textfield functions
    
    /// Sets the default text attributes for a UITextField
    ///
    /// - Parameters:
    ///   - textField: The UITextField whose attributes will be set.
    ///   - defaultText: The default text that will be set for the UITextField.
    func setTextFieldDefaultAttributes(for textField: UITextField, defaultText: String){
        textField.text = defaultText
        textField.textAlignment = .center
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // true if the text field is the top text field and default text is set
        let isTopDefaultText = (textField == topTextField && textField.text?.uppercased() == "TOP")
        // true if the text field is the bottom text field and default text is set
        let isBottomDefaultText = (textField == bottomTextField && textField.text?.uppercased() == "BOTTOM")
        // clear default text from text field
        if isTopDefaultText || isBottomDefaultText  {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - General Helper functions
    
    /// Presents a UIImagePickerController view for a specified source type.
    ///
    /// - Parameter sourceType: A UIImagePickerController source type. For example: .camera, .photoLibrary.
    func presentImagePicker(using sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Generates a memed image
    ///
    /// - Returns: A UIImage capturing everything in the current view, with the toolbar and navbar hidden.
    func generateMemedImage() -> UIImage {

        toolBar.isHidden = true
        navBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        toolBar.isHidden = false
        navBar.isHidden = false

        return memedImage
    }
    
    // MARK: - Keyboard related functions
    
    /// Shifts view up by the height value of the keyboard.
    ///
    /// - Parameter notification: Expects a notification of type keyboardWillShowNotification.
    @objc func keyboardWillShow(_ notification: Notification) {
        // Only adjust view if the bottom text field is clicked.
        // Sometimes keyboardWillShow gets called twice before keyboardWillHide is called.
        // Therefore view.frame.origin.y == 0 ensures the view is only shifted up once.
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    /// Sets the view to it's original coordinates
    ///
    /// - Parameter notification: Expects a notification of type keyboardWillHideNotification.
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    /// Returns the height of the keyboard.
    ///
    /// - Parameter notification: Expects a notification of type keyboardWillShowNotification.
    /// - Returns: The numeric value of the keyboard height.
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Notification Center methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - UIImagePickerController Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

