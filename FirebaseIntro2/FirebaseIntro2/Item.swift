//
//  Item.swift
//  FirebaseIntro2
//
//  Created by Dani Yalda on 2022-10-26.
//

import Foundation
import FirebaseFirestoreSwift

struct Item: Codable, Identifiable{
    
    @DocumentID var id: String?
    var name: String
  
    
}
