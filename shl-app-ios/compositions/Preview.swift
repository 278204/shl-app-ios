//
//  Preview.swift
//  shl-app-ios
//
//  Created by Pål on 2021-07-30.
//

import Foundation


func getPlayedGame() -> Game {
    return Game(game_id: 1, game_uuid: "123", away_team_code: "FHC", away_team_result: 0, home_team_code: "LHF", home_team_result: 2, start_date_time: Date().addingTimeInterval(TimeInterval(-2_000)), played: true)
}

func getLiveGame() -> Game {
    return Game(game_id: 1, game_uuid: "123", away_team_code: "FHC", away_team_result: 0, home_team_code: "LHF", home_team_result: 2, start_date_time: Date().addingTimeInterval(TimeInterval(-2_000)), played: false)
}

func getFutureGame() -> Game {
    return Game(game_id: 1, game_uuid: "123", away_team_code: "FHC", away_team_result: 0, home_team_code: "LHF", home_team_result: 2, start_date_time: Date().addingTimeInterval(TimeInterval(2_000)), played: false)
}
