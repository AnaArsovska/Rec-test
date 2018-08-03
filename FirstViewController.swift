//
//  FirstViewController.swift
//  RecTest
//
//  Created by Julia Sheth on 7/23/18.
//  Copyright © 2018 InternHack. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imgQRCode: UIImageView!

    @IBOutlet weak var btnAction: UIButton!

    @IBAction func performButtonAction(_ sender: Any) {
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            let data = textField.text?.data(using: String.Encoding.isoLatin1)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            
            imgQRCode.image = UIImage(ciImage: qrcodeImage)
            
            textField.resignFirstResponder()
            
            btnAction.setTitle("Clear", for: UIControlState.normal)
        }
        else {
            imgQRCode.image = nil
            qrcodeImage = nil
            btnAction.setTitle("Generate", for: UIControlState.normal)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

