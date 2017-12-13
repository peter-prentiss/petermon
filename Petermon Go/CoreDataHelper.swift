//
//  CoreDataHelper.swift
//  Petermon Go
//
//  Created by admin on 12/13/17.
//  Copyright © 2017 Peter Prentiss. All rights reserved.
//

import UIKit
import CoreData

func addAllPetermon() {
    createPetermon(name: "Peterchu", imageName: "pikachu-2")
    createPetermon(name: "Meowth", imageName: "meowth")
    createPetermon(name: "Pidgey", imageName: "pidgey")
    createPetermon(name: "Bulbasaur", imageName: "bullbasaur")
    createPetermon(name: "Charmander", imageName: "charmander")
    createPetermon(name: "Squirtle", imageName: "squirtle")
    createPetermon(name: "Eevee", imageName: "eevee")
    createPetermon(name: "Mew", imageName: "mew")
    createPetermon(name: "Snorlax", imageName: "snorlax")
    createPetermon(name: "Abra", imageName: "abra")
    createPetermon(name: "Psyduck", imageName: "psyduck")
}

func createPetermon(name:String, imageName:String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let petermon = Petermon(entity: Petermon.entity(), insertInto: context)
        petermon.name = name
        petermon.imageName = imageName
        
        try? context.save()
    }
}

func getAllPetermon() -> [Petermon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let peterData = try? context.fetch(Petermon.fetchRequest()) as? [Petermon] {
            if let petermons = peterData {
                if petermons.count == 0 {
                    addAllPetermon()
                    return getAllPetermon()
                }
                return petermons
            }
        }
    }
    return []
}

func getCaughtPetermon() -> [Petermon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Petermon.fetchRequest() as NSFetchRequest<Petermon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
        if let petermons = try? context.fetch(fetchRequest) {
            return petermons
        }
    }
    return []
}

func getUncaughtPetermon() -> [Petermon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Petermon.fetchRequest() as NSFetchRequest<Petermon>
        fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
        if let petermons = try? context.fetch(fetchRequest) {
            return petermons
        }
    }
    return []
}
