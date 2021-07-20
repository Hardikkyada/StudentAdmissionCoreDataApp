//
//  Addnoti.swift
//  StudentAdmission
//
//  Created by DCS on 15/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class Addnoti: UIViewController {

    var updatedata = ""
    
    private let datafield:UITextView = {
        let textf = UITextView()
        textf.textAlignment = .center
        textf.layer.borderWidth = 5
        textf.font = UIFont.boldSystemFont(ofSize: 20)
        return textf
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
        view.addSubview(datafield)
        view.addSubview(save)
        
        if updatedata != ""{
            let data = Noticedatahandlar.shared.fetchdata()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].content){
                    datafield.text = data[i].content
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        datafield.frame = CGRect(x: 40, y: view.safeAreaInsets.top + 20, width: view.width - 80, height: 150)

        save.frame = CGRect(x: 40, y: datafield.bottom + 20, width: view.width - 80, height: 60)
        
        
    }
    
    @objc func saveaction(){
        if updatedata == ""
        {
            Noticedatahandlar.shared.insert(data: datafield.text!){[weak self] in
                let alert = UIAlertController(title: "Success..", message: "Data Insert successfull", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }else{
            let data = Noticedatahandlar.shared.fetchdata()
            let n = data.count
            
            for i in 0..<n{
                if(updatedata == data[i].content){
                    let notitable = data[i]
                    Noticedatahandlar.shared.update(NB:notitable,data: datafield.text!){[weak self] in
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
