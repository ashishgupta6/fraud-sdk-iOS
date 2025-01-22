////
////  IntelligenceResponseStorage.swift
////  Sign3Intelligence
////
////  Created by Ashish Gupta on 20/12/24.
////
//
//import RealmSwift
//
//internal struct RealmDataStorage {
//    
//    internal func saveIntelligenceResponseToRealm(_ dataRequest: DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal,
//                               _ intelligenceResponse: IntelligenceResponse) {
//        DispatchQueue.global(qos: .default).async {
//            do {
//                // Encrypt Response
//                let iv = CryptoGCM.getIvHeader()
//                let jsonData = try JSONEncoder().encode(intelligenceResponse)
//                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
//                    return
//                }
//                var encryptedResponse = try CryptoGCM.encrypt(
//                    jsonString,
//                    iv
//                )
//                encryptedResponse.append(" \(iv.base64EncodedString())")
//                let responseObject = IntelligenceResponseObject.create(response: encryptedResponse)
//                
//                // Creating a new realm instance on the background thread to perform write operation
//                let realm = try! Realm()
//                try realm.write {
//                    realm.add(responseObject)
//                }
//                Log.i("Response saved successfully.", encryptedResponse)
//            } catch {
//                Log.e("saveIntelligenceResponseToRealm:", "\(error.localizedDescription)")
//            }
//        }
//    }
//    
//    internal func fetchIntelligenceFromRealm(completion: @escaping (IntelligenceResponse?) -> Void) {
//        DispatchQueue.global(qos: .default).async {
//            do {
//                // Using a Realm instance on the current thread (thread-safe)
//                let realm = try Realm()
//                if let intelligenceResponseObject = realm.objects(IntelligenceResponseObject.self).last {
//                    // Decrypt Response
//                    var nonceBase64 = ""
//                    var ciphertextBase64 = ""
//                    let response = intelligenceResponseObject.response
//                    let trimmedString = response.split(separator: " ")
//                    if trimmedString.count > 1 {
//                        nonceBase64 = String(trimmedString[1])
//                        ciphertextBase64 = String(trimmedString[0])
//                    }
//
//                    let decryptedResponse = CryptoGCM.decrypt(ciphertextBase64: ciphertextBase64, nonceBase64: nonceBase64)
//
//                    if let jsonData = decryptedResponse?.data(using: .utf8) {
//                        let decoder = JSONDecoder()
//                        do {
//                            let response = try decoder.decode(IntelligenceResponse.self, from: jsonData)
//                            DispatchQueue.main.async {
//                                completion(response)
//                            }
//                            return
//                        } catch {
//                            Log.e("Error decoding JSON:", error.localizedDescription)
//                        }
//                    }
//                }
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                Log.e("fetchIntelligenceFromRealm:", error.localizedDescription)
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            }
//        }
//    }
//
//}
