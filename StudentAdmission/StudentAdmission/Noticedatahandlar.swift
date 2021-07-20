//
//  Noticedatahandlar.swift
//  StudentAdmission
//
//  Created by DCS on 15/07/21.
//  Copyright © 2021 HRK. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Noticedatahandlar{
    
    static let shared = Noticedatahandlar()
    
    let appdeleget = UIApplication.shared.delegate as! AppDelegate
    let context:NSManagedObjectContext
    
    private init(){
        context = appdeleget.persistentContainer.viewContext
    }
    func save(){
        appdeleget.saveContext()
    }
    
    func insert(data:String,over: @escaping () -> Void){
        
        let noti = NoticeBoard(context: context)
        noti.content = data
        save()
        over()
    }
    
    func delete(NB:NoticeBoard,over: @escaping () -> Void){
      
        context.delete(NB)
        
        save()
        over()
    }
    
    func update(NB:NoticeBoard,data:String,over: @escaping () -> Void){
        
        NB.content = data
        
        save()
        over()
    }
    
    func fetchdata() -> [NoticeBoard]{
        let datareq:NSFetchRequest<NoticeBoard> = NoticeBoard.fetchRequest()
        
        do{
            let dataarray = try context.fetch(datareq)
            return dataarray
        }catch{
            print(error)
            let dataa = [NoticeBoard]()
            return dataa
        }
    }
}

