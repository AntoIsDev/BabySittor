//
//  ContentView.swift
//  BabySittor
//
//  Created by Antonin De Almeida on 13/09/2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject private var usersFetch = UsersFetchRequest.shared

    var body: some View {
            VStack {
                if usersFetch.users.isEmpty {
                    Button(action: {
                        usersFetch.fetchUsers()
                    }, label: {
                        Text("Rafraîchir")
                        Image(systemName: "arrow.clockwise")
                    })
                } else {
                    Text("Liste des utilisateurs").font(.title)
                    List(usersFetch.users, id: \.uuid) { user in
                        UserListElementView(user: user)
                    }.refreshable {
                        usersFetch.fetchUsers()
                    }
                }
            }.alert(isPresented: $usersFetch.error, content: {
                Alert(title: Text("Connexion impossible"),
                      message: Text("Une erreur nous empêche de récupérer la liste des utilisateurs"),
                      dismissButton: .default(Text("OK")))
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
