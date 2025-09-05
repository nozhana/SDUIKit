//
//  TimerWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/1/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("deadline", type: Date.self, optional: true), .custom("countdown", type: Int.self, optional: true), .custom("properties", type: TextWidget.Data.Properties.self, optional: true))
public struct TimerWidget: View {
    private let now = Date.now
    public var body: some View {
        let deadline: Date = data.deadline ?? now.advanced(by: Double(data.countdown ?? 0))
        let showsHours = abs(deadline.timeIntervalSince(now)) > 3600
        Group {
            if now < deadline {
                Text(timerInterval: now...deadline, showsHours: showsHours)
            } else {
                Text(verbatim: "– ")
                + Text(timerInterval: deadline...(.distantFuture), countsDown: false, showsHours: showsHours)
            }
        }
        .ifLet(data.properties) { content, properties in
            content
                .ifLet(properties.fontSize) { content, size in
                    content
                        .font(.system(size: size))
                }
                .fontWeight(properties.fontWeight?.systemFontWeight)
                .fontDesign(properties.fontDesign?.systemFontDesign)
                .fontWidth(properties.fontWidth?.systemFontWidth)
        }
    }
}

extension TimerWidget.Data {
    typealias Properties = TextWidget.Data.Properties
    
    public enum CodingKeys: String, CodingKey {
        case deadline, countdown, properties
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let deadlineISO8601 = deadline?.formatted(.iso8601)
        try container.encodeIfPresent(deadlineISO8601, forKey: .deadline)
        try container.encodeIfPresent(countdown, forKey: .countdown)
        try container.encodeIfPresent(properties, forKey: .properties)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let deadlineISO8601 = try container.decodeIfPresent(String.self, forKey: .deadline)
        let deadline: Date?
        if let deadlineISO8601 {
            deadline = try Date(deadlineISO8601, strategy: .iso8601)
        } else {
            deadline = nil
        }
        let countdown = try container.decodeIfPresent(Int.self, forKey: .countdown)
        guard deadline != nil || countdown != nil else {
            throw WidgetError.unsupportedWidgetType
        }
        let properties = try container.decodeIfPresent(Properties.self, forKey: .properties)
        
        self.deadline = deadline
        self.countdown = countdown
        self.properties = properties
    }
}

#Preview("Deadline") {
    let json = """
{
    "padding": 16,
    "content": {
        "deadline": "2025-09-01T05:00:00+03:30",
        "properties": "34-bold-serif-expanded"
    }
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Countdown") {
    let json = """
{
    "padding": 16,
    "content": {
        "countdown": 300,
        "properties": "44-heavy--compressed"
    }
}
"""
    
    WidgetContainer(json: json)
}
