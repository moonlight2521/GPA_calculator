//
//  ViewController.swift
//  GPA Calculator
//
//  Created by Zun Lin on 2/8/18.
//  Copyright © 2018 Zun Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //Adding grades
    @IBOutlet weak var courseNameTF: UITextField!
    @IBOutlet weak var assignPointTF: UITextField!
    @IBOutlet weak var assignMaxTF: UITextField!
    @IBOutlet weak var assignPercentTF: UITextField!
    @IBOutlet weak var midPointTF: UITextField!
    @IBOutlet weak var midMaxTF: UITextField!
    @IBOutlet weak var midPercentTF: UITextField!
    @IBOutlet weak var finalPointTF: UITextField!
    @IBOutlet weak var finalMaxTF: UITextField!
    @IBOutlet weak var finalPercentTF: UITextField!
    @IBOutlet weak var creditsTF: UITextField!
    @IBOutlet weak var addCourseBT: UIButton!
    @IBOutlet weak var gpaLB: UILabel!
    
    //chalkboard
    @IBOutlet weak var courseOneLB: UILabel!
    @IBOutlet weak var courseTwoLB: UILabel!
    @IBOutlet weak var courseThreeLB: UILabel!
    @IBOutlet weak var courseFourLB: UILabel!
    @IBOutlet weak var gradeOne: UIImageView!
    @IBOutlet weak var gradeTwo: UIImageView!
    @IBOutlet weak var gradeThree: UIImageView!
    @IBOutlet weak var gradeFour: UIImageView!
    //delete course
    @IBOutlet weak var courseNumTF: UITextField!
    @IBOutlet weak var deleteCourseBT: UIButton!
    
    //set Groups
    var firstGroup = [UIView]()
    var secondGroup = [UIView]()

    var labelGroup = [UILabel]()
    var imageGroup = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set the UI to the group
        
        firstGroup = [courseNameTF, assignPointTF, assignMaxTF, assignPercentTF, midPointTF, midMaxTF, midPercentTF, finalPointTF, finalMaxTF, finalPercentTF, creditsTF, courseNumTF]
        
        secondGroup = [courseOneLB, courseTwoLB, courseThreeLB, courseFourLB, gradeOne, gradeTwo, gradeThree, gradeFour]
        
        labelGroup = [courseOneLB, courseTwoLB, courseThreeLB, courseFourLB]
        imageGroup = [gradeOne, gradeTwo, gradeThree, gradeFour]
        
        //set second group to hidden
        for each in secondGroup{
            each.isHidden = true
        }
        
        //set delegate to the text field
        courseNameTF.delegate = self
        assignPointTF.delegate = self
        assignMaxTF.delegate = self
        assignPercentTF.delegate = self
        midPointTF.delegate = self
        midMaxTF.delegate = self
        midPercentTF.delegate = self
        finalPointTF.delegate = self
        finalMaxTF.delegate = self
        finalPercentTF.delegate = self
        creditsTF.delegate = self
        courseNumTF.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //delegate function to make sure keyboard close
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //add a structure for the courses
    struct Course{
        var courseName: String
        var gpa: Double
    }
    //store variable in the array
    var courseList = [String]()
    var creditList = [Int]()
    var gpaList = [Double]()
    var count = 0
    
    @IBAction func addCourse (_ submit: UIButton){
        let percentOne = Double(assignPercentTF.text!)
        let percentTwo = Double(midPercentTF.text!)
        let percentThree = Double(finalPercentTF.text!)
        let assignPoint = Double(assignPointTF.text!)
        let midPoint = Double(midPointTF.text!)
        let finalPoint = Double(finalPointTF.text!)
        let assignMax = Double(assignMaxTF.text!)
        let midMax = Double(midMaxTF.text!)
        let finalMax = Double(finalMaxTF.text!)
        let courseName = courseNameTF.text!
        let credit = Int(creditsTF.text!)
    
        if (assignPointTF.text?.isEmpty ?? true) || (assignMaxTF.text?.isEmpty ?? true) || (assignPercentTF.text?.isEmpty ?? true) || (midPointTF.text?.isEmpty ?? true) || (midMaxTF.text?.isEmpty ?? true) || (midPercentTF.text?.isEmpty ?? true) || (finalPointTF.text?.isEmpty ?? true) || (finalMaxTF.text?.isEmpty ?? true) || (finalPercentTF.text?.isEmpty ?? true) || (creditsTF.text?.isEmpty ?? true){
            
            let alert = UIAlertController(title: "Error", message: "Please enter all the entries!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if ((0 < assignPoint!) && (assignPoint! > assignMax!)) || ((0 < midPoint!) && (midPoint! > midMax!)) || ((0 < finalPoint!) && (finalPoint! > finalMax!)) {
            let alert = UIAlertController(title: "Error", message: "Your point is not in the range", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (percentOne! + percentTwo! + percentThree! < 100) || (percentOne! + percentTwo! + percentThree! > 100) {
            
            let alert = UIAlertController(title: "Error", message: "Your total percent don't add up to 100%", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if count > 3 {
            
            let alert = UIAlertController(title: "Error", message: "Too many courses, Please delete some", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            
            let courseGPA = calculateGPA(assignPoint: assignPoint!, assignMax: assignMax!, assignPercent: percentOne!, midPoint: midPoint!, midMax: midMax!, midPercent: percentTwo!, finalPoint: finalPoint!, finalMax: finalMax!, finalPercent: percentThree!)
            courseList.append(courseName)
            creditList.append(credit!)
            gpaList.append(courseGPA)
            let label = labelGroup[count]
            label.text = String(count + 1)+". " + String(courseList[count]) + " | " + String(creditList[count])
            label.isHidden = false
            count = count + 1
            courseNumTF.text = String(count)
            let gpaTotal = (gpaList.reduce(0, +) / Double(count))
            let gradeImage = gpaImageFinder(gpa: courseGPA, image: imageGroup[count - 1])
            gradeImage.isHidden = false
            gpaLB.text = "GPA: " + String(format: "%.2f",gpaTotal)
                if gpaTotal > 3.0{
                    gpaLB.textColor = UIColor.green
                } else if gpaTotal > 2.0 {
                    gpaLB.textColor = UIColor.orange
                } else {
                    gpaLB.textColor = UIColor.red
                }
        }
    }
    @IBAction func deleteCourse (_ submit: UIButton){
        if (courseNumTF.text?.isEmpty ?? true){
            let alert = UIAlertController(title: "Error", message: "Please enter the number in the chalkboard!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else{
        let courseNum = Int(courseNumTF.text!)! - 1
        if (courseNum + 1 > count) || (count <= 0) {
                let alert = UIAlertController(title: "Error", message: "Please enter the number in the chalkboard!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
        } else {
                var label = labelGroup[courseNum] //UIview
                let image = imageGroup[courseNum]
                courseList.remove(at: courseNum)
                creditList.remove(at: courseNum)
                gpaList.remove(at: courseNum)

                var index = 0
                while index < count {
                    label = labelGroup[index]
                    label.text = ""
                    image.image = UIImage(named: "")
                    imageGroup[index].isHidden = true
                    index = index + 1
                }
                count = count - 1
                index = 0
                while index < count {
                    label = labelGroup[index]
                    label.text = String(index + 1)+". " + String(courseList[index]) + " | " + String(creditList[index])
                    let gradeImage = gpaImageFinder(gpa: gpaList[index], image: imageGroup[index])
                    gradeImage.isHidden = false
                    index = index + 1
                }
                let gpaTotal = (gpaList.reduce(0, +) / Double(count))
                gpaLB.text = "GPA: " + String(format: "%.2f",gpaTotal)
                if gpaTotal > 3.0{
                    gpaLB.textColor = UIColor.green
                } else if gpaTotal > 2.0 {
                    gpaLB.textColor = UIColor.orange
                } else {
                    gpaLB.textColor = UIColor.red
                }
                courseNumTF.text = String(count)
        }
        }
    }
    //GPA calculation
    func calculateGPA(assignPoint: Double, assignMax: Double, assignPercent: Double, midPoint: Double, midMax: Double, midPercent: Double, finalPoint: Double, finalMax: Double, finalPercent: Double) -> Double {
        let total = Double((((assignPoint / assignMax) * (assignPercent / 100)) + ((midPoint / midMax) * (midPercent / 100)) + ((finalPoint / finalMax) * (finalPercent / 100))) * 100)
        if total >= 90 {
            return 4.0
        } else if total >= 80 {
        return 3.0
        } else if total >= 70 {
            return 2.0
        } else if total >= 60{
            return 1.0
        } else {
            return 0.0
        }
    }
    //get the gpa image base on the gpa point
    func gpaImageFinder (gpa: Double, image: UIImageView) -> UIImageView{
        if gpa >= 4.0{
            image.image = UIImage(named: "grade_a")
            return image
        } else if gpa >= 3.0 {
            image.image = UIImage(named: "grade_b")
            return image
        } else if gpa >= 2.0 {
            image.image = UIImage(named: "grade_c")
            return image
        } else if gpa >= 1.0 {
            image.image = UIImage(named: "grade_d")
            return image
        } else {
            image.image = UIImage(named: "grade_f")
            return image
        }
    }
}

