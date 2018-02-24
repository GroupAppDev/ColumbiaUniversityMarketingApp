//
//  AddItemViewController.swift
//  Markt
//
//  Created by Jeremy Kim on 1/7/18.
//  Copyright © 2018 jkim. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import SwiftyJSON
import FirebaseAuth.FIRUser

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedRow = 0
    var selectedPhoto: UIImage?
    
    @IBOutlet var itemTypePickerView: UIPickerView!
    
    @IBOutlet var sellingLAbel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var pictureView: UIImageView!
    
    enum ItemType: String {
        case Books = "Books"
        case Electronics = "Electronics"
        case Leases = "Leases"
    }
    
    let Types = ["\(ItemType.Books.rawValue)","\(ItemType.Electronics.rawValue)","\(ItemType.Leases.rawValue)"]
    
    func switchToBookTabCont(){
        tabBarController!.selectedIndex = 0
    }
    
    func handleProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerController, animated: true)
    }
    
    @IBAction func post(_ sender: Any) {
        
        let price = Double(priceTextField.text!)
        if (self.pictureView.image == nil || (self.priceTextField.text?.isEmpty)!) {
            return
        }
        
        else {
            switch self.selectedRow{
            case 0:
                PostService.createBook(for: selectedPhoto!, price: price!)
            case 1:
                PostService.createElectronics(for: selectedPhoto!, price: price!)
            case 2:
                PostService.createLease(for: selectedPhoto!, price: price!)
            default:
                return
            }
        
//            self.performSegue(withIdentifier: "PostToPage", sender: self)
            switchToBookTabCont()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        priceTextField.text = ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTypePickerView.delegate = self
        itemTypePickerView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView))
        pictureView.addGestureRecognizer(tapGesture)
        pictureView.isUserInteractionEnabled = true
        
    }
    
    
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureView.image = image
            selectedPhoto = image
        }
        
        dismiss(animated: true)
    }
    
}
