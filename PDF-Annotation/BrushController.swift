//
//  BrushController.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/10/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit

class BrushController: UIViewController {
	
	@IBOutlet var sizeSlider: UISlider!
	@IBOutlet var opacitySlider: UISlider!
	
	@IBOutlet var sizeLabel: UILabel!
	@IBOutlet var opacityLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sizeSlider.value = Float(brushWidth)
		opacitySlider.value = Float(brushOpacity)
		
		sizeLabel.text = String(brushWidth) + " px"
		opacityLabel.text = String(Int(brushOpacity * 100)) + "%"
		
		self.preferredContentSize = CGSize(width: 250,height: 400)
	}
	
	@IBAction func SizeChange(sender: AnyObject) {
		brushWidth = Int(sizeSlider.value)
		sizeLabel.text = String(brushWidth) + " px"
	}
	
	@IBAction func OpacityChange(sender: AnyObject) {
		brushOpacity = CGFloat(opacitySlider.value)
		opacityLabel.text = String(Int(brushOpacity * 100)) + "%"
	}
	
	@IBAction func ColorPicked(sender: AnyObject) {
		ChangeDefinedColor(sender.currentTitle!!)
	}
}
