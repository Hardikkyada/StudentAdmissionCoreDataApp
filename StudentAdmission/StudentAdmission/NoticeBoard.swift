//
//  NoticeBoard.swift
//  StudentAdmission
//
//  Created by DCS on 15/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit

class NBoard: UIViewController {

    private let mytableview = UITableView()
    
    private var loaddata = [NoticeBoard]()
    
     let user = UserDefaults.standard.string(forKey: "user")
    
    private let namelabel:UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.textAlignment = .center
        //lab.backgroundColor = UIColor.gray
        return lab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NoticeBoard"
        self.view.backgroundColor = .white
        
        
        if user == "Admin"{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        }
        
        
        view.addSubview(namelabel)
        view.addSubview(mytableview)
        
        setuptable()
        mytableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        loaddata = Noticedatahandlar.shared.fetchdata()
        mytableview.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mytableview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height-view.safeAreaInsets.top - (mytableview.top + 50))
        
    }
    
    @objc func add(){
        let vc = Addnoti()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension NBoard:UITableViewDataSource,UITableViewDelegate{
    
    func setuptable(){
        mytableview.dataSource = self
        mytableview.delegate = self
        mytableview.register(UITableViewCell.self, forCellReuseIdentifier: "loaddata")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loaddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loaddata", for: indexPath)
        cell.textLabel?.text = loaddata[indexPath.row].content
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if(user == "Admin")
            {
                let vc = Addnoti()
                vc.updatedata = loaddata[indexPath.row].content!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if(user == "Admin")
            {
                let notitable = loaddata[indexPath.row]
                if editingStyle == .delete{
                    mytableview.beginUpdates()
        
                    Noticedatahandlar.shared.delete(NB: notitable){ [weak self] in
                        self?.loaddata.remove(at: indexPath.row)
                        self?.mytableview.deleteRows(at: [indexPath], with: .fade)
                    }
                    mytableview.endUpdates()
        
                }
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

