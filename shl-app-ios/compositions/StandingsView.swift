//
//  StandingsView.swift
//  HockeyPal
//
//  Created by Pål Forsberg on 2021-01-08.
//

import SwiftUI

struct StandingsView: View {
    @State var standings = [Standing]()
    @EnvironmentObject var teams: TeamsData
    @EnvironmentObject var starredTeams: StarredTeams
    var provider: DataProvider? = DataProvider()
    
    var body: some View {
        NavigationView {
            List(standings) { item in
                NavigationLink(destination: TeamView(teamCode: item.team_code, standing: item)) {
                    HStack() {
                        Text("#\(item.rank)")
                            .font(.system(size: 16, design: .rounded))
                            .fontWeight(.semibold)
                            .points()
                            .frame(width: 30)
                            .foregroundColor(Color.gray)
                        TeamAvatar(item.team_code)
                        Image(
                            systemName: "star.circle.fill")
                            .foregroundColor(starredTeams.isStarred(teamCode: item.team_code) ? Color(UIColor.systemYellow) : Color.clear)
                            .frame(width: 10)
                            .padding(.leading, -10)
                        Text("\(item.gp)").points()
                        Text(item.getPointsPerGame()).points()
                        Text("\(item.points)").points()
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }.buttonStyle(PlainButtonStyle())
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("SHL"))
            .onAppear(perform: {
                guard self.standings.isEmpty else {
                    return
                }
                provider?.getStandings { (result) in
                    self.standings = result.data
                }
            })
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            })
        }
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        let starredTeams = StarredTeams()
        starredTeams.addTeam(teamCode: "SAIK")
        return StandingsView(standings: [getStanding("LHF", rank: 1), getStanding("SAIK", rank: 14)], provider: nil)
            .environmentObject(TeamsData())
            .environmentObject(starredTeams)
    }
    static func getStanding(_ teamCode: String, rank: Int) -> Standing {
        return Standing(team_code: teamCode, gp: 4, rank: rank, points: 3)
    }
}
