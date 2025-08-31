//
//  ButtonWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftUI

public struct ButtonWidget: WidgetView {
    public var data: Data
    
    @Environment(\.setPath) private var setPath
    @Environment(\.pushPath) private var pushPath
    @Environment(\.popPath) private var popPath
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        Button {
            switch data.action {
            case .setPath(let elements):
                setPath(elements)
            case .pushPath(let element):
                pushPath(element)
            case .popPath:
                popPath()
            }
        } label: {
            AnyWidgetView(data.label)
        }
    }
}

extension ButtonWidget {
    public struct Data: Decodable, Sendable {
        public var action: Action
        public var label: AnyWidget
        
        public init(action: Action, label: AnyWidget) {
            self.action = action
            self.label = label
        }
    }
    
    public enum Action: Decodable, Sendable, RawRepresentable {
        case setPath(elements: [String])
        case pushPath(element: String)
        case popPath
        
        public enum CodingKeys: String, CodingKey {
            case action
            case arguments
        }
        
        public init(from decoder: any Decoder) throws {
            if let container = try? decoder.container(keyedBy: CodingKeys.self),
               let action = try? container.decode(String.self, forKey: .action) {
                var args = (try? container.decodeIfPresent([String].self, forKey: .arguments)) ?? []
                if let stringArgsConcat = try? container.decodeIfPresent(String.self, forKey: .arguments) {
                    let stringArgs = stringArgsConcat.split(separator: "/").map(String.init)
                    args.append(contentsOf: stringArgs)
                }
                let argsConcat = args.joined(separator: "/")
                var rawValue = action
                if !argsConcat.isEmpty {
                    rawValue += "-" + argsConcat
                }
                guard let value = Action(rawValue: rawValue) else {
                    throw WidgetError.unknownDataType(rawValue)
                }
                self = value
            } else if let container = try? decoder.singleValueContainer(),
                      let rawValue = try? container.decode(String.self) {
                guard let value = Action(rawValue: rawValue) else {
                    throw WidgetError.unknownDataType(rawValue)
                }
                self = value
            } else {
                throw WidgetError.unsupportedWidgetType
            }
        }
        
        public init?(rawValue: String) {
            guard let match = rawValue.wholeMatch(of: /(set|push|pop)(?:-((?:\/?\w+)+))?/)?.output else {
                return nil
            }
            
            switch match.1 {
            case "set":
                let components = match.2?.split(separator: "/").map(String.init) ?? []
                self = .setPath(elements: components)
            case "push":
                let component = String(match.2 ?? "")
                self = .pushPath(element: component)
            case "pop":
                self = .popPath
            default:
                return nil
            }
        }
        
        public var rawValue: String {
            switch self {
            case .setPath(let elements):
                "set-\(elements.joined(separator: "/"))"
            case .pushPath(let element):
                "set-\(element)"
            case .popPath:
                "pop"
            }
        }
    }
}

#Preview {
    let json = """
{
    "action": "pop",
    "label": "Tap me!"
}
"""
    
    try! ButtonWidget(json: json)
}
