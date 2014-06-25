//
//  ArrayTest.swift
//  TitansProject
//
//  Created by desmond on 6/25/14.
//  Copyright (c) 2014 Phoenix. All rights reserved.
//

import Foundation

class ArrayTest :MyFavLinqTests
    
{
    
    func testEach() {
        var times = 0
        [1,2,3].each { n in times++; return }

        
    }
    
    
}
