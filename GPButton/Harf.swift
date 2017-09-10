//
//  Harf.swift
//  GPkey
//
//  Created by Alireza Keshavarzi on 4/18/17.
//  Copyright © 2017 ark. All rights reserved.
//

class Harf {
    
    let name: String
    let face: String
    let output: String
    let returnable: Bool
    let spaceReturnable: Bool
    
    init(name:String, face:String, output:String, returnable:Bool, spaceReturnable:Bool)
    {
        self.name = name
        self.face = face
        self.output = output
        self.returnable = returnable
        self.spaceReturnable = spaceReturnable
    }
    
}
