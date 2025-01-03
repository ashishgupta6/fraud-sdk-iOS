////
////  IntelligenceResponseObject.swift
////  Sign3Intelligence
////
////  Created by Ashish Gupta on 20/12/24.
////
//
//import RealmSwift
//
//// Define IntelligenceResponse as a Realm Object
//internal class IntelligenceResponseObject: Object, Codable {
//    @Persisted var response: String
//    
//    enum CodingKeys: String, CodingKey {
//        case response = "response"
//    }
//    
//    static func create(
//        response: String
//    ) -> IntelligenceResponseObject {
//        let object = IntelligenceResponseObject()
//        object.response = response
//        return object
//    }
//}
