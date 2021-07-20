//
//  datahandlar.swift
//  StudentAdmission
//
//  Created by DCS on 09/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class datahandlar{
    static let shared = datahandlar()
    
    let appdeleget = UIApplication.shared.delegate as! AppDelegate
    let context:NSManagedObjectContext
    
    private init()
    {
       context = appdeleget.persistentContainer.viewContext
    }
    
    func save(){
        appdeleget.saveContext()
    }
    
    func insert(id: String,name:String,pwd:String,dob:Date,cname:String,over: @escaping () -> Void)
    {
        let std = Student(context: context)
        std.spid = id
        std.name = name
        std.pwd = pwd
        std.dob = dob
        std.classname = cname
        
        save()
        over()
    }
    
    func delete(stud:Student,over: @escaping() -> Void) {
        context.delete(stud)
        
        save()
        over()
    }
    
    func update(std:Student,id: String,name:String,pwd:String,dob:Date,cname:String,over: @escaping () -> Void){
        std.spid = id
        std.name = name
        std.pwd = pwd
        std.dob = dob
        std.classname = cname
        save()
        over()
    }
    
    func changepass(stud:Student,pwd:String,over: @escaping() -> Void) {
        
        stud.pwd = pwd
        
        save()
        over()
    }
    
    func fetchdata() -> [Student] {
        
        let fetchr:NSFetchRequest<Student> = Student.fetchRequest()
        
        do{
            let dataarray = try context.fetch(fetchr)
            return dataarray
        }catch{
            print(error)
            let dataarray = [Student]()
            return dataarray
        }
    }
    
    func fetchbyid(id:String) -> [Student]{
        let fetchreq:NSFetchRequest<Student> = Student.fetchRequest()
        
        do{
            let dataarray = try context.fetch(fetchreq)
            var studdata = [Student]()
            let n = dataarray.count
            
            for i in 0..<n{
                if(dataarray[i].spid == id){
                    studdata = [dataarray[i]]
                }
            }
            return studdata
        }catch{
            print(error)
            let studdata = [Student]()
            return studdata
        }
    }
}
