//
//  ButtonWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SDUIUtilities
import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("action", type: ButtonAction.self), .custom("style", type: ButtonStyle.self, optional: true), .widget("label"))
public struct ButtonWidget: View {
    @Environment(\.setPath) private var setPath
    @Environment(\.pushPath) private var pushPath
    @Environment(\.popPath) private var popPath
    @Environment(\.showAlert) private var showAlert
    
    @Environment(\.openURL) private var openURL
    
    public var body: some View {
        Button {
            switch data.action {
            case .setPath(let elements):
                setPath(elements)
            case .pushPath(let element):
                pushPath(element)
            case .popPath:
                popPath()
            case .showAlert(let title, let message, let actions):
                showAlert(title, message: message, actions: actions)
            case .openURL(let url):
                openURL(url)
            case .none:
                break
            }
        } label: {
            AnyWidgetView(data.label)
        }
        .ifLet(data.style) { content, style in
            switch style {
            case .automatic:
                content.buttonStyle(.automatic)
            case .plain:
                content.buttonStyle(.plain)
            case .borderless:
                content.buttonStyle(.borderless)
            case .bordered:
                content.buttonStyle(.bordered)
            case .borderedProminent:
                content.buttonStyle(.borderedProminent)
            }
        }
    }
}

public extension ButtonWidget {
    typealias Style = ButtonStyle
    typealias Action = ButtonAction
}

public enum ButtonStyle: String, Codable, Sendable {
    case automatic, plain, borderless, bordered, borderedProminent
}

public enum ButtonAction: Codable, Sendable, RawRepresentable {
    case setPath(elements: [String])
    case pushPath(element: String)
    case popPath
    case showAlert(title: String, message: String, actions: [(action: ButtonAction, label: AnyWidget)])
    case openURL(url: URL)
    case none
    
    public enum CodingKeys: String, CodingKey {
        case action = "type"
        case arguments
    }
    
    private enum ArgumentsCodingKeys: String, CodingKey {
        case elements, element, title, message, actions, url
    }
    
    private struct AlertAction: Codable, Sendable {
        var action: ButtonAction
        var label: AnyWidget
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .setPath(let elements):
            var argsContainer = container.nestedContainer(keyedBy: ArgumentsCodingKeys.self, forKey: .arguments)
            try container.encode("set", forKey: .action)
            try argsContainer.encode(elements, forKey: .elements)
        case .pushPath(element: let element):
            var argsContainer = container.nestedContainer(keyedBy: ArgumentsCodingKeys.self, forKey: .arguments)
            try container.encode("push", forKey: .action)
            try argsContainer.encode(element, forKey: .element)
        case .popPath:
            try container.encode("pop", forKey: .action)
        case .showAlert(let title, let message, let actions):
            var argsContainer = container.nestedContainer(keyedBy: ArgumentsCodingKeys.self, forKey: .arguments)
            try container.encode("alert", forKey: .action)
            try argsContainer.encode(title, forKey: .title)
            try argsContainer.encode(message, forKey: .message)
            let alertActions = actions.map { AlertAction(action: $0.0, label: $0.1) }
            try argsContainer.encode(alertActions, forKey: .actions)
        case .openURL(let url):
            var argsContainer = container.nestedContainer(keyedBy: ArgumentsCodingKeys.self, forKey: .arguments)
            try container.encode("url", forKey: .action)
            try argsContainer.encode(url, forKey: .url)
        case .none:
            try container.encode("none", forKey: .action)
        }
    }
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
           let action = try? container.decode(String.self, forKey: .action) {
            if let argsContainer = try? container.nestedContainer(keyedBy: ArgumentsCodingKeys.self, forKey: .arguments) {
                try self.init(action: action, argsContainer: argsContainer)
                return
            }
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
            guard let value = ButtonAction(rawValue: rawValue) else {
                throw WidgetError.unknownDataType(rawValue)
            }
            self = value
        } else if let container = try? decoder.singleValueContainer(),
                  let rawValue = try? container.decode(String.self) {
            guard let value = ButtonAction(rawValue: rawValue) else {
                throw WidgetError.unknownDataType(rawValue)
            }
            self = value
        } else {
            throw WidgetError.unsupportedWidgetType
        }
    }
    
    private init(action: String, argsContainer: KeyedDecodingContainer<ArgumentsCodingKeys>) throws {
        switch action {
        case "set":
            let elements = try argsContainer.decodeIfPresent([String].self, forKey: .elements)
            self = .setPath(elements: elements ?? [])
        case "push":
            if let element = try argsContainer.decodeIfPresent(String.self, forKey: .element) {
                self = .pushPath(element: element)
            } else {
                self = .none
            }
        case "pop":
            self = .popPath
        case "alert":
            let title = try argsContainer.decode(String.self, forKey: .title)
            let message = try argsContainer.decodeIfPresent(String.self, forKey: .message) ?? ""
            let actions = try argsContainer.decodeIfPresent([AlertAction].self, forKey: .actions) ?? []
            self = .showAlert(title: title, message: message, actions: actions.map { ($0.action, $0.label) })
        case "url":
            let url = try argsContainer.decode(URL.self, forKey: .url)
            self = .openURL(url: url)
        case "none":
            self = .none
        default:
            throw WidgetError.unknownDataType(action)
        }
    }
    
    public init?(rawValue: String) {
        guard let match = rawValue.wholeMatch(of: /(set|push|pop|alert|url|none)(?:-((?:.|\n)+))?/)?.output else {
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
        case "alert":
            let args = match.2?.split(separator: "-", omittingEmptySubsequences: false).map(String.init) ?? []
            let (title, message) = (args.first ?? "", args.dropFirst().first ?? "")
            let cancelTitle = args.dropFirst(2).first
            // ???: Support more actions?
            let actions: [ShowAlertAction.ActionItem] = [(action: .none, label: "\(cancelTitle ?? "")")]
            self = .showAlert(title: title, message: message, actions: actions)
        case "url":
            let urlString = String(match.2 ?? "")
            guard let url = URL(string: urlString) else {
                return nil
            }
            self = .openURL(url: url)
        case "none":
            self = .none
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .setPath(let elements):
            return "set-\(elements.joined(separator: "/"))"
        case .pushPath(let element):
            return "set-\(element)"
        case .popPath:
            return "pop"
        case .showAlert(let title, let message, _):
            var key = "alert-\(title)"
            if !message.isEmpty {
                key += "-\(message)"
            }
            return key
        case .openURL(let url):
            return "url-\(url.absoluteString)"
        case .none:
            return "none"
        }
    }
}

#Preview("Shorthand alert") {
    let json = """
{
    "scaffold": "Home",
    "content": {
        "action": "alert-Hey there!-Would you like to try our new product?\\nIt's fifty percent off!-No thanks",
        "style": "borderedProminent",
        "label": "Tap me!"
    }
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Expanded alert") {
    let json = """
{
    "scaffold": "Home",
    "destinations": {
        "test": {
            "title": "Test",
            "content": {
                "layout": "list",
                "items": [
                    {
                        "action": "push-forth",
                        "label": "Go forth"
                    },
                    {
                        "action": "pop",
                        "label": "Go back"
                    },
                    {
                        "action": {
                            "type": "alert",
                            "arguments": {
                                "title": "Info",
                                "message": "Made with 💜\\n@nozhana ® 2025",
                                "actions": [
                                    {
                                        "action": "none",
                                        "label": "Whatever"
                                    },
                                    {
                                        "action": "url-https://github.com/nozhana",
                                        "label": "Open GitHub"
                                    }
                                ]
                            }
                        },
                        "label": {
                            "title": "Info",
                            "icon": "icon-info.circle.fill"
                        }
                    }
                ]
            }
        },
        "forth": {
            "title": "Forth",
            "content": {
                "action": "pop",
                "label": "Go back"
            }
        }
    },
    "content": {
        "action": {
            "type": "alert",
            "arguments": {
                "title": "Hey There!",
                "actions": [
                    {
                        "action": "set-test",
                        "label": "Go to Test"
                    }
                ]
            }
        },
        "style": "borderedProminent",
        "label": "Tap me!"
    }
}
"""
    
    WidgetContainer(json: json)
}
