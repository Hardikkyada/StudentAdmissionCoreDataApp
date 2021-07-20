//
//  AddStud.swift
//  StudentAdmission
//
//  Created by DCS on 14/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation
import UIKit

class AddStud: UIViewController {
    
    var updatedata = ""
    
    private let id:UITextField = {
        let textf = UITextField()
        textf.placeholder = "Enter id"
        textf.textAlignment = .center
        textf.borderStyle = .roundedRect
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    private let name:UITextField = {
        let textf = UITextField()
        textf.placeholder = "Enter name"
        textf.textAlignment = .center
        textf.borderStyle = .roundedRect
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()
    
    private let classname:UITextField = {
        let textf = UITextField()
        textf.placeholder = "Enter class no/name"
        textf.text?.uppercased()
        textf.textAlignment = .center
        textf.borderStyle = .roundedRect
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
    }()

    private let dob:UIDatePicker = {
        let dob = UIDatePicker()
        dob.datePickerMode = .date
        dob.timeZone = TimeZone(secondsFromGMT: 0)
        return dob
    }()
    
    
    private let save:UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.addTarget(self, action: #selector(saveaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(id)
        view.addSubview(name)
        view.addSubview(dob)
        view.addSubview(classname)
        view.addSubview(save)
        
        if updatedata != ""{
            let data = datahandlar.shared.fetchdata()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].spid){
                    id.text = data[i].spid
                    name.text = data[i].name
                    dob.date = data[i].dob!
                    classname.text = data[i].classname
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        id.frame = CGRect(x: 40, y: view.safeAreaInsets.top + 20, width: view.width - 80, height: 60)
        name.frame = CGRect(x: 40, y: id.bottom + 20, width: view.width - 80, height: 60)
        classname.frame = CGRect(x: 40, y: name.bottom + 20, width: view.width - 80, height: 60)
        dob.frame = CGRect(x: 40, y: classname.bottom + 20, width: view.width - 80, height: 250)
        save.frame = CGRect(x: 40, y: dob.bottom + 20, width: view.width - 80, height: 60)
        
        
    }
    
    @objc func saveaction(){
        if updatedata == ""
        {
        datahandlar.shared.insert(id: id.text!, name: name.text!, pwd: id.text!, dob: dob.date,cname: classname.text!){[weak self] in
            let alert = UIAlertController(title: "Success..", message: "Data inserted successfull", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
            self?.navigationController?.popViewController(animated: true)
        }
        }else{
            let data = datahandlar.shared.fetchdata()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].spid){
                    let studtable = data[i]
                    print(data[i])
                    datahandlar.shared.update(std: studtable, id: id.text!, name: name.text!, pwd: id.text!, dob: dob.date,cname: classname.text!){[weak self] in
                        let alert = UIAlertController(title: "Success..", message: "Data Update successfull", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true, completion: nil)
                            
                        }
                        self?.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
        }
}
}
