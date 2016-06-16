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
	
	@IBOutlet weak var typeSelect: UISegmentedControl!
	@IBOutlet weak var fillSelect: UISegmentedControl!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sizeSlider.value = Float(brushWidth)
		opacitySlider.value = Float(brushOpacity)
		
		sizeLabel.text = String(brushWidth) + " px"
		opacityLabel.text = String(Int(brushOpacity * 100)) + "%"
		
		if drawingLine {
			typeSelect.selectedSegmentIndex = 0
			fillSelect.enabled = false
		} else {
			if drawingSquare {
				typeSelect.selectedSegmentIndex = 1
			} else {
				typeSelect.selectedSegmentIndex = 2
			}
			fillSelect.enabled = true
		}
		
		if filledShape {
			fillSelect.selectedSegmentIndex = 0
		} else {
			fillSelect.selectedSegmentIndex = 1
		}
		
		
		self.preferredContentSize = CGSize(width: 250,height: 400)
	}
	
	@IBAction func SizeChange(sender: AnyObject) {
		brushWidth = Int(sizeSlider.value)
		sizeLabel.text = String(brushWidth) + " px"
	}
	
	@IBAction func OpacityChange(sender: AnyObject) {
		brushOpacity = opacitySlider.value
		opacityLabel.text = String(Int(brushOpacity * 100)) + "%"
	}
	
	@IBAction func ColorPicked(sender: AnyObject) {
		ChangeDefinedColor(sender.currentTitle!!)
	}
	
	@IBAction func TypeSelect(sender: AnyObject) {
		if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! == "Line" {
			fillSelect.enabled = false
			drawingLine = true
		} else {
			fillSelect.enabled = true
			drawingLine = false
			if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! == "Square" {
				drawingSquare = true
			} else {
				drawingSquare = false
			}
		}
	}
	
	@IBAction func FillSelect(sender: AnyObject) {
		if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! == "Filled" {
			filledShape = true
		} else {
			filledShape = false
		}
	}
	
}
