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

    let urlBabysittor = "https://preprod-api.bbst.eu/test_tech"
    static let shared = UsersFetchRequest()

    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "preprod-api.bbst.eu")

    @Published var users: [User] = []
    @Published var error: Bool = false

    init() {

        startNetworkReachabilityObserver()
        fetchUsers()

    }

    private func startNetworkReachabilityObserver() { // Listener for network availability

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

    private func errorHandler(error: Bool) {
        if error {
            self.error = true
            self.users = [] // Invalidate data if network goes down
        } else {
            self.error = false
            fetchUsers() // Try to fetch data if network is back
        }

    }

    func fetchUsers() {

        AF.request(urlBabysittor).responseString { [weak self] response in
            guard let value = response.value else { // If response doesn't contain data
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
