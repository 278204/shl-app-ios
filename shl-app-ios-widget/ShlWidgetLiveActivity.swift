//
//  shl_app_ios_widgetLiveActivity.swift
//  shl-app-ios-widget
//
//  Created by Pål on 2023-02-11.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetTeamLogo: View {
    var code: String
    var size: CGFloat = 40.0

    var body: some View {
        if let teamImage = UIImage(named: self.getImageName()) {
            Image(uiImage: teamImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size, alignment: .center)
            
        } else {
            Image(systemName: "photo")
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
    
    func getImageName() -> String {
        if size > 128 {
            return "\(code.lowercased())-big.png"
        }
        return "\(code.lowercased()).png"
    }

}

struct WidgetTeamAvatar: View {
    var code: String
    var body: some View {
        VStack(spacing: 5) {
            WidgetTeamLogo(code: code)
            Text(code)
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
struct LiveActivityReportView: View {
    var context: ActivityViewContext<ShlWidgetAttributes>
    
    var body: some View {
        HStack(alignment: .top, spacing: 40) {
            WidgetTeamAvatar(code: context.attributes.homeTeam)
            VStack(spacing: 3) {
                HStack(spacing: 10) {
                    Text("\(context.state.report.homeScore)")
                    Text("-").font(.system(size: 22, weight: .black, design: .rounded))
                    Text("\(context.state.report.awayScore)")
                }
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                
                HStack(spacing: 3) {
                    if context.state.getStatus() == .coming {
                        Text("\(context.attributes.startDateTime.getFormattedDate()) \(context.attributes.startDateTime.getFormattedTime())")
                    } else if let s = context.state.report.status {
                        Text(LocalizedStringKey(s))
                    }
                    if let s = context.state.report.gametime, context.state.getStatus()?.isGameTimeApplicable() ?? false {
                        Text("•")
                        Text(s)
                    }
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            WidgetTeamAvatar(code: context.attributes.awayTeam)
        }
        .font(.system(size: 14, weight: .heavy, design: .rounded))
    }
}

@available(iOSApplicationExtension 16.1, *)
struct LiveActivityEventView: View {
    var event: LiveActivityEvent
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Spacer()
                if let t = event.teamCode {
                    WidgetTeamLogo(code: t, size: 25)
                }
                VStack(alignment: .leading) {
                    Text(event.title)
                    if let b = event.body {
                        Text(b)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                }
                Spacer()
            }
            .padding(.top, 10).padding(.bottom, 12)

        }
        .font(.system(size: 14, weight: .bold, design: .rounded))
        .background(Color(uiColor: .systemBackground).opacity(0.2))
    }
}

@available(iOSApplicationExtension 16.1, *)
struct ShlWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShlWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityReportView(context: context)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: context.state.event == nil ? 20 : 10, trailing: 0))
            if let e = context.state.event {
                LiveActivityEventView(event: e)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 10) {
                        WidgetTeamLogo(code: context.attributes.homeTeam, size: 38)
                        Text("\(context.state.report.homeScore)")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: 10) {
                        Text("\(context.state.report.awayScore)")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                        WidgetTeamLogo(code: context.attributes.awayTeam, size: 38)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center) {
                        HStack {
                            if let s = context.state.report.status {
                                Text(LocalizedStringKey(s))
                            }
                            if let s = context.state.report.gametime, context.state.getStatus()?.isGameTimeApplicable() ?? false {
                                Text("•")
                                Text(s)
                            }
                        }
                    }.font(.system(size: 16, weight: .bold, design: .rounded))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if let e = context.state.event {
                        HStack {
                            if let t = e.teamCode {
                                WidgetTeamLogo(code: t, size: 25)
                            }
                            VStack(alignment: .leading) {
                                Text(e.title)
                                if let b = e.body {
                                    Text(b).font(.system(size: 14, weight: .semibold, design: .rounded))
                                }
                            }
                        }.font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                }
            } compactLeading: {
                HStack {
                    WidgetTeamLogo(code: context.attributes.homeTeam, size: 28)
                    Text("\(context.state.report.homeScore)")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
            } compactTrailing: {
                HStack {
                    Text("\(context.state.report.awayScore)")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                    WidgetTeamLogo(code: context.attributes.awayTeam, size: 28)
                }
            } minimal: {
                WidgetTeamLogo(code: context.attributes.homeTeam, size: 28)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.yellow)
        }
    }
}

@available(iOS 16.2, *)
struct ShlWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = ShlWidgetAttributes(homeTeam: "LHF", awayTeam: "FHC", gameUuid: "game_uuid_123", startDateTime: Date())
    static let report = LiveActivityReport(homeScore: 2, awayScore: 0, status: "Period1", gametime: "12:23")
    static let event = LiveActivityEvent(title: "MÅÅL! 🎉", body: nil, teamCode: "LHF")
    static let contentState = ShlWidgetAttributes.ContentState(report: report, event: event)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
            .environment(\.locale, .init(identifier: "sv"))
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
            .environment(\.locale, .init(identifier: "sv"))
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
            .environment(\.locale, .init(identifier: "sv"))
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
            .environment(\.locale, .init(identifier: "sv"))
    }
}
