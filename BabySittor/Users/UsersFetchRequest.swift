//
//  UsersFetchRequest.swift
//  BabySittor
//
//  Created by Antonin De Almeida on 13/09/2022.
//

import Alamofire
import Foundation
import SwiftyJSON

class UsersFetchRequest: ObservableObject {

    static let shared = UsersFetchRequest()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "preprod-api.bbst.eu")

    @Published var users: [User] = []
    @Published var error: Bool = false

    init() {

        startNetworkReachabilityObserver()
        fetchUsers()

    }

    func startNetworkReachabilityObserver() {

        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable :
                self.errorHandler(error: true)
            case .reachable(.ethernetOrWiFi) :
                self.errorHandler(error: false)
            default :
                self.errorHandler(error: false)
            }
        }

    }

    func errorHandler(error: Bool) {
        if error {
            self.error = true
            self.users = []
        } else {
            self.error = false
            fetchUsers()
        }

    }

    func fetchUsers() {

        AF.request("https://preprod-api.bbst.eu/test_tech").responseString { [weak self] response in
            guard let value = response.value else {
                self?.errorHandler(error: true)
                return
            }
            self?.errorHandler(error: false)
            let swiftyJsonVar = JSON(parseJSON: value)
            if let users = swiftyJsonVar["data"].arrayObject {
                for user in users {
                    let user = user as! [String: AnyObject]
                    let firstname = user["first_name"] as! String
                    let lastname = user["last_name"] as! String
                    let defaultPictureUrl = user["default_picture_url"] as! String
                    let averageReviewScore = user["average_review_score"] as? Double
                    self?.users.append(
                        User(firstname: firstname,
                             lastname: lastname,
                             defaultPictureUrl: defaultPictureUrl,
                             averageReviewScore: averageReviewScore)
                    )
                }
            }
        }

    }
}
