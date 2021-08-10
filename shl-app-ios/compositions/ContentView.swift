//
//  ContentView.swift
//  HockeyPal
//
//  Created by Pål Forsberg on 2021-01-08.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var starredTeams = StarredTeams()
    @ObservedObject var teams = TeamsData()
    @ObservedObject var gameData = GamesData(data: [])
    @ObservedObject var standings = StandingsData(data: [])
    @ObservedObject var settings = AppDelegate.settings
    
    var provider: DataProvider? = DataProvider()
    
    @State
    var userService: UserService?

    var body: some View {
        TabView {
            GamesView(provider: provider).tabItem { Label("Home", systemImage: "house") }
            StandingsView(provider: provider).tabItem { Label("Standings", systemImage: "list.bullet") }
        }.onAppear(perform: {
            provider?.getTeams(completion: { ts in
                teams.setTeams(teams: ts)
            })
            userService = UserService(provider: provider, settings: settings, starredTeams: starredTeams)
        })
        .environmentObject(starredTeams)
        .environmentObject(standings)
        .environmentObject(teams)
        .environmentObject(gameData)
        .environmentObject(settings)
        .background(Color(UIColor.systemGroupedBackground))
        .accentColor(Color(UIColor.systemYellow))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let teams = TeamsData()
        teams.setTeams(teams: [Team(code: "LHF", name: "Luleå HF"),
                               Team(code: "FHC", name: "Frölunda HC"),
                               Team(code: "SAIK", name: "Skellefteå AIK")])
        
        let starredTeams = StarredTeams()
        starredTeams.addTeam(teamCode: "LHF")
        return ContentView(
                    teams: teams,
                    gameData: GamesData(data: [getLiveGame(), getLiveGame(),
                                               getPlayedGame(), getPlayedGame(),
                                               getFutureGame(), getFutureGame()]),
                    standings: StandingsData(data: [getStanding("LHF", rank: 1), getStanding("TIK", rank: 2)]),
                    provider: nil)
            .environment(\.locale, .init(identifier: "sv"))
    }
}
