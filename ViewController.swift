//
//  ViewController.swift
//  words_french
//
//  Created by Yuriy Zinkovets on 29.03.2018.
//  Copyright © 2018 Yuriy Zinkovets. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var textLabel : UILabel!
    @IBOutlet var french : UITextField!
    @IBOutlet public var russian : UITextField!
    @IBOutlet var buttonAdd : UIButton!
    @IBOutlet var buttonStart : UIButton!
    @IBOutlet var buttonLook : UIButton!
    public var dataText : String!
    public var word : String!
    public var allText : String = ""
    public var allTextRu : String = ""
    public var words_arr : Array<String> = Array<String>()
    public var all : Array<String> =  Array<String>()
    public var allRu : Array<String> = Array<String>()
    public var pr : DarwinBoolean!
    public var choice : DarwinBoolean!
    public var control : DarwinBoolean = true

    override func viewDidLoad() {
        super.viewDidLoad()
        french.delegate = self
        russian.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    @IBAction func buttonAdd(sender : AnyObject){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        let newWord = NSManagedObject(entity: entity!, insertInto: context)
        if french.text?.count != 0 && russian.text?.count != 0 {
            do{
                let data = try context.fetch(request)
                print(data as! [NSManagedObject])
                if data.count != 0{
                    for object in data as! [NSManagedObject]{
                        if object.value(forKey: "french") != nil{
                            let look = object.value(forKey: "french") as! String
                            if look == french.text{
                                control = false
                            }
                        }
                    }
                }
            }
            catch{
                print("bad")
            }
            print(control)
            if control != false{
                let fr = french.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let ru = russian.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                newWord.setValue(fr, forKey: "french")
                newWord.setValue(ru, forKey: "russian")
                do{
                    try context.save()
                    let warning = UIAlertController(title: "Completed", message: "Added", preferredStyle: .alert)
                    let but = UIAlertAction(title: "Ok", style: .default)
                    warning.addAction(but)
                    self.present(warning, animated: true){
                        print("Added")
                    }
                }
                catch{
                    print("Have some faults")
                }
            }
            else{
                let warning = UIAlertController(title: "Warning", message: "You have a same word", preferredStyle: .alert)
                let but = UIAlertAction(title: "Ok", style: .default)
                warning.addAction(but)
                self.present(warning, animated: true){
                    print("Added")
                }
            }
            control = true
        }
        else{
            let warning = UIAlertController(title: "Warning", message: "Write something", preferredStyle: .alert)
            let but = UIAlertAction(title: "Ok", style: .default)
            warning.addAction(but)
            self.present(warning, animated: true){
                print("Error: write something")
            }
        }
        french.text = ""
        russian.text = ""
    }
    @IBAction func buttonStart(sender : AnyObject){
        choice = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        request.returnsObjectsAsFaults = false
        do{
            let data = try context.fetch(request)
            for object in data as! [NSManagedObject]{
                print(object)
                if (object.value(forKey: "french") == nil){
                    try context.delete(object)
                    try context.save()
                }
                else{
                let d = object.value(forKey: "french") as! String
                words_arr.append(d)
                }
            }
        }
        catch{
            print("bad")
        }
        print(words_arr)
        if(words_arr.count != 0){
            word = words_arr[Int(arc4random_uniform(UInt32(words_arr.count)))]
        }
        else{
            word = "error"
        }
    }
    @IBAction func buttonLook(sender: AnyObject){
        choice = false
        all = []
        allRu = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        do{
            let data = try context.fetch(request)
            if data.count != 0{
                for object in data as! [NSManagedObject]{
                    if object.value(forKey: "french") != nil{
                        all.append(object.value(forKey:"french") as! String)
                        allRu.append(object.value(forKey: "russian") as! String)
                        print(all)
                    }
                }
            }
            else{
                let warning = UIAlertController(title: "Warning", message: "You don't have words", preferredStyle: .alert)
                let but = UIAlertAction(title: "Ok", style: .default)
                warning.addAction(but)
                self.present(warning, animated: true){
                    print("Error: you don't have words")
                }
            }
        }
        catch{
            print("fail")
        }
        print(all)
        allText = ""
        allTextRu = ""
        for i in all{
            allText += i + "\n"
        }
        for i in allRu{
            allTextRu += i + "\n"
        }
        print(allText)
    }
    @IBAction func viewTapped(sender : AnyObject){
        view.endEditing(true)
        russian.resignFirstResponder()
        french.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if choice == true{
            let valera: ViewController2 = segue.destination as! ViewController2
            if word != "error"{
                valera.testik = word
                valera.word_arr = words_arr
            }
            else{
                let warning = UIAlertController(title: "Warning", message: "You don't have some words",
                                                preferredStyle: .alert)
                let but = UIAlertAction(title: "Ok", style: .default)
                warning.addAction(but)
                self.present(warning, animated: true){
                    print("Completed")
                }
            }
        }
        else{
            let alls: ViewController3 = segue.destination as! ViewController3
            print(allText)
            alls.preText = allText
            alls.preTextRu = allTextRu
        }
 }
}

