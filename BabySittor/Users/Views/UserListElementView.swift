//
//  UserListElementView.swift
//  BabySittor
//
//  Created by Antonin De Almeida on 13/09/2022.
//

import SwiftUI

struct UserListElementView: View {

    let user: User

    var body: some View {

        HStack {
            AsyncImage(url: URL(string: user.defaultPictureUrl))
                .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
                .clipShape(Circle())
            Spacer()
            Text(user.firstname).frame(minWidth: 70, maxWidth: 70).font(.system(size: 12)).lineLimit(1)
            Spacer()
            Text(user.lastname).frame(minWidth: 70, maxWidth: 70).font(.system(size: 12)).lineLimit(1)
            Spacer()
            HStack {
                Text(String(format: "%.2f", user.averageReviewScore ?? 0)).font(.system(size: 12))
                Image(systemName: "star.circle")
            }
        }

    }
}

struct UserListElementView_Previews: PreviewProvider {
    static var previews: some View {
        UserListElementView(user: User(
            firstname: "Antonin",
            lastname: "De Almeida",
            defaultPictureUrl: "https://randomuser.me/api/portraits/thumb/men/15.jpg",
            averageReviewScore: 4.5689889))
    }
}
