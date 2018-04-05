//
//  ViewController2.swift
//  words_french
//
//  Created by Yuriy Zinkovets on 29.03.2018.
//  Copyright © 2018 Yuriy Zinkovets. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController2 : UIViewController, UITextFieldDelegate{
    @IBOutlet var ask : UILabel!
    @IBOutlet var answer : UITextField!
    @IBOutlet var buttonNext : UIButton!
    @IBOutlet var buttonDelete : UIButton!
    var testik : String = ""
    var askk : String!
    var word : String!
    var word_arr : Array<String> = Array<String>()
    var check : DarwinBoolean!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ask.text = testik
        answer.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func viewTapped(sender : AnyObject){
        answer.resignFirstResponder()
    }
    @IBAction func del(sender: AnyObject){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        var reason : DarwinBoolean!
        var list : Array<String> = Array<String>()
        askk = ask.text
        request.predicate = NSPredicate(format : "french = %@", askk)
        do{
            var data =  try context.fetch(request)
            print(data)
            if data.count != 0{
                for object in data as! [NSManagedObject]{
                    context.delete(object)
                }
                try context.save()
                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
                data =  try context.fetch(request)
                if data.count != 0{
                    reason = true
                    let cong = UIAlertController(title: "Word", message: "Deleted", preferredStyle: .alert)
                    let but = UIAlertAction(title: "Ok", style: .default)
                    cong.addAction(but)
                    self.present(cong, animated: true){
                        print("Completed")
                    }
                    print("Deleted")
                }
                else{
                    reason = false
                }
            }
            else{
                reason = false
            }
        }
        catch{
            reason = false
            //print("Not deleted")
        }
        if reason == true{
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
            do{
            let data = try context.fetch(request)
                for object in data as! [NSManagedObject]{
                    let w = object.value(forKey: "french") as! String!
                    if w != nil{
                        list.append(w!)
                    }
                }
            }
            catch{
                print("bad")
            }
            if list.count != 0{
                ask.text = list[Int(arc4random_uniform(UInt32(list.count)))]
                check = false
            }
            else{
                self.check = true
                }
            }
        else{
            print("empty")
        }
    }
    @IBAction func next(sender: AnyObject){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format : "french = %@", ask.text!)
        do{
            let data =  try context.fetch(request)
            for object in data as! [NSManagedObject]{
                let t = object.value(forKey:"russian") as! String
                if answer.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == t {
                    let cong = UIAlertController(title: "Congratulations!", message: "Good!", preferredStyle: .alert)
                    let but = UIAlertAction(title: "Next!", style: .default)
                    cong.addAction(but)
                    self.present(cong, animated: true){
                        //print("Completed")
                    }
                }
                else{
                    let cong = UIAlertController(title: "Oops", message: "Bad:c", preferredStyle: .alert)
                    let but = UIAlertAction(title: "Next!", style: .default)
                    cong.addAction(but)
                    self.present(cong, animated: true){
                       // print("Sa")
                        
                    }
                }
                //print(answer.text!)
                //print(t)
            }
        }
        catch{
            print("bad")
        }
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        do{
            word_arr = []
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject]{
                let w = data.value(forKey: "french") as! String
                print(w)
                word_arr.append(w)
                //print("goodd")
            }
        }
        catch{
            print("bad")
        }
        ask.text = word_arr[Int(arc4random_uniform(UInt32(word_arr.count)))]
        answer.text = ""
        //print(word_arr[Int(arc4random_uniform(UInt32(word_arr.count)))])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if check == true{
            let vv: ViewController = segue.destination as! ViewController
            vv.pr = true
        }
    }
}
