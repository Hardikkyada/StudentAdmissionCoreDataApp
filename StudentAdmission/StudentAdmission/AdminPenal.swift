//
//  adminpenal.swift
//  StudentAdmission
//
//  Created by DCS on 09/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import UIKit
import CoreData



class AdminPenal: UIViewController {
    
    private let mytableview = UITableView()
    
    private var loaddata = [Student]()
    private var classdata = [Student]()
    
    private let namelabel:UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.textAlignment = .center
        //lab.backgroundColor = UIColor.gray
        return lab
    }()
    
    private let logout:UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let NoticBoard:UIButton = {
        let btn = UIButton()
        btn.setTitle("NoticBoard", for: .normal)
        btn.addTarget(self, action: #selector(NBaction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.6)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    @objc func logoutaction(){
        UserDefaults.standard.removeObject(forKey: "session_id")
        print("logout")

        navigationController?.popViewController(animated: true)
    }
    
    @objc func NBaction(){
        let vc = NBoard()
        navigationController?.pushViewController(vc,animated: true)
    }
    
    private let classname:UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegment(withTitle: "ALl", at: 0, animated: true)
        seg.insertSegment(withTitle: "FYMCA", at: 1, animated: true)
        seg.insertSegment(withTitle: "SYMCA", at: 2, animated: true)
        seg.insertSegment(withTitle: "TYMCA", at: 3, animated: true)
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(segclick), for: .valueChanged)
        return seg
    }()
    
    @objc func segclick(){
    
        loaddata = datahandlar.shared.fetchdata()
        
        let title = classname.titleForSegment(at: classname.selectedSegmentIndex)
        let n = loaddata.count
        
        if classname.selectedSegmentIndex != 0{
            
            for i in 0..<n
            {
                if(title == loaddata[i].classname)
                {
                    classdata.append(loaddata[i])
                }
            }
            loaddata = classdata
            mytableview.reloadData()
            classdata = []
        }
        else
        {
            loaddata = datahandlar.shared.fetchdata()
            mytableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Admin"
        self.view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        view.addSubview(namelabel)
        view.addSubview(logout)
        view.addSubview(NoticBoard)
        view.addSubview(mytableview)
        view.addSubview(classname)
        
        setuptable()
        mytableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       loaddata = datahandlar.shared.fetchdata()
        mytableview.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        classname.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 5, width: view.width - 60, height: 40)
        
        mytableview.frame = CGRect(x: 0, y: classname.bottom, width: view.width, height: view.height-view.safeAreaInsets.top - (mytableview.top + 130))
        
        NoticBoard.frame = CGRect(x: 20, y: mytableview.bottom, width: view.width - 60, height: 40)
        logout.frame = CGRect(x: 20, y: NoticBoard.bottom + 2, width: view.width - 60, height: 40)
        
    }
    
    @objc func add(){
        let vc = AddStud()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*private func fetchdata(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do{
            let data = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            loaddata.removeAll()
            
            for i in data{
                loaddata.append(i.lastPathComponent)
            }
            
        }catch{
            print(error)
        }
        mytableview.reloadData()
    }*/
}
extension AdminPenal:UITableViewDataSource,UITableViewDelegate{
    
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
        cell.textLabel?.text = loaddata[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(loaddata[indexPath.row])
        
        print(indexPath.row)
        let vc = AddStud()
        vc.updatedata = loaddata[indexPath.row].spid!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let stdtable = loaddata[indexPath.row]
        if editingStyle == .delete{
            mytableview.beginUpdates()

            datahandlar.shared.delete(stud: stdtable){ [weak self] in
                self?.loaddata.remove(at: indexPath.row)
                self?.mytableview.deleteRows(at: [indexPath], with: .fade)
            }
            mytableview.endUpdates()
           
        }
    }
}
