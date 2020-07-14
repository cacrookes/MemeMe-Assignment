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
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - Global variables
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDefaultAttributes(for: topTextField, defaultText: "TOP")
        setTextFieldDefaultAttributes(for: bottomTextField, defaultText: "BOTTOM")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
        // FIXME: this does not work
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
        // TODO: dismiss keyboard
        return true
    }
    
    // MARK: - Helper functions
    
    /// Presents a UIImagePickerController view for a specified source type.
    ///
    /// - Parameter sourceType: a UIImagePickerController source type. For example: .camera, .photoLibrary.
    func presentImagePicker(using sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
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

