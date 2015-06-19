//
//  Person.swift
//  F59DataRecursiveRelations

import Foundation

class Person : NSObject {
    
    var name : String?
    var age : Int = 0
    var mom : Person?
    var dad : Person?
    var children : [Person]?
}
