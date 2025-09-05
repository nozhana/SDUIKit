//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/2/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("transition", type: Transition.self), .custom("animation", type: Animation.self, optional: true), .string("stateKey", optional: true), .content)
public struct TransitionWidget: View {
    @WidgetState private var state
    
    public var body: some View {
        let show = data.stateKey.map { state[$0] as? Bool ?? false } ?? true
        VStack {
            if show {
                AnyWidgetView(data.content)
                    .transition(data.transition.systemTransition)
            }
        }
        .animation(data.animation?.systemAnimation ?? .default, value: show)
    }
}

extension TransitionWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case transition, animation, content
        case stateKey = "if"
    }
}

public enum Transition: Codable, Sendable {
    case `default`
    case fade
    case scale(downTo: Double = .zero, anchor: Anchor = .center)
    case blurReplace
    case move(edge: Edge)
    case offset(x: Double = .zero, y: Double = .zero)
    indirect case combined(Transition, Transition)
    
    public static let scale = scale()
    
    public func combined(with transition: Transition) -> Transition {
        .combined(self, transition)
    }
}

public struct Anchor: Codable, Sendable, Equatable, CustomStringConvertible {
    public var x: Double
    public var y: Double
    
    public init(x: Double = 0.5, y: Double = 0.5) {
        self.x = x
        self.y = y
    }
    
    public init(unitPoint: UnitPoint) {
        self.x = unitPoint.x
        self.y = unitPoint.y
    }
    
    fileprivate init(key: String) throws {
        switch key {
        case "top": self = .top
        case "leading": self = .leading
        case "bottom": self = .bottom
        case "trailing": self = .trailing
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        case "center": self = .center
        default:
            if let match = key.wholeMatch(of: /x:(?'x'[\d.-]+),y:(?'y'[\d.-]+)/)?.output,
               let x = Double(match.x), let y = Double(match.y) {
                self = .init(x: x, y: y)
            } else {
                throw WidgetError.unknownDataType(key)
            }
        }
    }
    
    public var description: String {
        switch self {
        case .top: "self"
        case .leading: "leading"
        case .bottom: "bottom"
        case .trailing: "trailing"
        case .topLeading: "topLeading"
        case .topTrailing: "topTrailing"
        case .bottomLeading: "bottomLeading"
        case .bottomTrailing: "bottomTrailing"
        case .center: "center"
        default: "x:\(x),y:\(y)"
        }
    }
    
    public var unitPoint: UnitPoint {
        .init(x: x, y: y)
    }
    
    public static let top = Anchor(unitPoint: .top)
    public static let leading = Anchor(unitPoint: .leading)
    public static let bottom = Anchor(unitPoint: .bottom)
    public static let trailing = Anchor(unitPoint: .trailing)
    public static let topLeading = Anchor(unitPoint: .topLeading)
    public static let topTrailing = Anchor(unitPoint: .topTrailing)
    public static let bottomLeading = Anchor(unitPoint: .bottomLeading)
    public static let bottomTrailing = Anchor(unitPoint: .bottomTrailing)
    public static let center = Anchor(unitPoint: .center)
}

extension Transition: RawRepresentable {
    @MainActor
    public var systemTransition: AnyTransition {
        switch self {
        case .default: .identity
        case .fade: .opacity
        case .scale(let scale, let anchor): .scale(scale: scale, anchor: anchor.unitPoint)
        case .blurReplace: .init(.blurReplace)
        case .move(let edge): .move(edge: edge.systemEdge)
        case .offset(let x, let y): .offset(x: x, y: y)
        case .combined(let transition, let transition2):
            transition.systemTransition.combined(with: transition2.systemTransition)
        }
    }
    
    public init?(rawValue stringKey: String) {
        let matches = stringKey.matches(of: /(fade|scale|blur|move|offset)(?:-([^|]+))?/)
        guard !matches.isEmpty else {
            return nil
        }
        var transition = Transition.default
        for match in matches {
            guard let next = try? Transition(output: match.output) else {
                return nil
            }
            transition = .combined(transition, next)
        }
        self = transition
    }
    
    public var rawValue: String {
        switch self {
        case .default:
            "default"
        case .fade:
            "fade"
        case .scale(let scale, let anchor):
            "scale-\(scale)-\(anchor)"
        case .blurReplace:
            "blur"
        case .move(let edge):
            "move-\(edge.rawValue)"
        case .offset(let x, let y):
            "offset-x:\(x),y:\(y)"
        case .combined(let transition, let transition2):
            "\(transition.rawValue)|\(transition2.rawValue)"
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringKey = try container.decode(String.self)
        guard let transition = Transition(rawValue: stringKey) else {
            throw WidgetError.unsupportedWidgetType
        }
        self = transition
    }
    
    private init(output: (wholeMatch: Substring, key: Substring, argument: Substring?)) throws {
        switch output.key {
        case "default":
            self = .default
        case "fade":
            self = .fade
        case "scale":
            guard let arguments = output.argument?.split(separator: "-") else {
                self = .scale
                return
            }
            let scale = arguments.compactMap { Double($0) }.first ?? .zero
            let anchor = arguments.compactMap { try? Anchor(key: String($0)) }.first ?? .center
            self = .scale(downTo: scale, anchor: anchor)
        case "blur":
            self = .blurReplace
        case "move":
            guard let argument = output.argument?.split(separator: ":").last,
                  let edge = Edge(rawValue: String(argument)) else {
                throw WidgetError.unknownDataType("\(output.argument ?? "")")
            }
            self = .move(edge: edge)
        case "offset":
            guard let arguments = output.argument?.split(separator: ","),
                  !arguments.isEmpty else {
                throw WidgetError.unknownDataType("\(output.argument ?? "")")
            }
            if let size = arguments.compactMap({ Double($0) }).first {
                self = .offset(x: size, y: size)
            } else {
                let xStr = output.argument?.firstMatch(of: /x:(?'x'[\d.-]+)/)?.output.x
                let yStr = output.argument?.firstMatch(of: /y:(?'y'[\d.-]+)/)?.output.y
                let x: Double = Double(xStr ?? "0") ?? .zero
                let y: Double = Double(yStr ?? "0") ?? .zero
                self = .offset(x: x, y: y)
            }
        default:
            throw WidgetError.unknownDataType("\(output.wholeMatch)")
        }
    }
}

public enum Animation: Codable, Sendable {
    case `default`
    case spring(duration: TimeInterval = defaultDuration, bounce: Double = .zero)
    case smooth(duration: TimeInterval = defaultDuration, extraBounce: Double = .zero)
    case snappy(duration: TimeInterval = defaultDuration, extraBounce: Double = .zero)
    case bouncy(duration: TimeInterval = defaultDuration, extraBounce: Double = .zero)
    case interactiveSpring(duration: TimeInterval = defaultDuration, extraBounce: Double = .zero)
    
    indirect case delayed(Animation, delay: TimeInterval)
    indirect case repeated(Animation, repeatCount: Int? = nil, autoreverses: Bool = true)
    indirect case speedModified(Animation, speed: Double)
    
    public static let defaultDuration = 0.5
    
    public static let spring = spring()
    public static let smooth = smooth()
    public static let snappy = snappy()
    public static let bouncy = bouncy()
    public static let interactiveSpring = interactiveSpring()
    
    public func delayed(_ delay: TimeInterval) -> Animation {
        .delayed(self, delay: delay)
    }
    
    public func speed(_ speed: Double) -> Animation {
        .speedModified(self, speed: speed)
    }
    
    public func repeatForever(autoreverses: Bool = true) -> Animation {
        .repeated(self, autoreverses: autoreverses)
    }
    
    public func repeatCount(_ count: Int, autoreverses: Bool = true) -> Animation {
        .repeated(self, repeatCount: count, autoreverses: autoreverses)
    }
    
    @MainActor
    public var systemAnimation: SwiftUI.Animation {
        switch self {
        case .default:
                .default
        case .spring(let duration, let bounce):
                .spring(duration: duration, bounce: bounce)
        case .smooth(let duration, let extraBounce):
                .smooth(duration: duration, extraBounce: extraBounce)
        case .snappy(let duration, let extraBounce):
                .snappy(duration: duration, extraBounce: extraBounce)
        case .bouncy(let duration, let extraBounce):
                .bouncy(duration: duration, extraBounce: extraBounce)
        case .interactiveSpring(let duration, let extraBounce):
                .interactiveSpring(duration: duration, extraBounce: extraBounce)
        case .delayed(let animation, let delay):
            animation.systemAnimation.delay(delay)
        case .repeated(let animation, let repeatCount?, let autoreverses):
            animation.systemAnimation.repeatCount(repeatCount, autoreverses: autoreverses)
        case .repeated(let animation, repeatCount: nil, let autoreverses):
            animation.systemAnimation.repeatForever(autoreverses: autoreverses)
        case .speedModified(let animation, let speed):
            animation.systemAnimation.speed(speed)
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case curve, duration, bounce, extraBounce, delay, repeatCount, repeatForever, autoreverses, speed
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .default:
            try container.encode("default", forKey: .curve)
        case .spring(let duration, let bounce):
            try container.encode("spring", forKey: .curve)
            try container.encode(duration, forKey: .duration)
            try container.encode(bounce, forKey: .bounce)
        case .smooth(let duration, let extraBounce):
            try container.encode("smooth", forKey: .curve)
            try container.encode(duration, forKey: .duration)
            try container.encode(extraBounce, forKey: .extraBounce)
        case .snappy(let duration, let extraBounce):
            try container.encode("snappy", forKey: .curve)
            try container.encode(duration, forKey: .duration)
            try container.encode(extraBounce, forKey: .extraBounce)
        case .bouncy(let duration, let extraBounce):
            try container.encode("bouncy", forKey: .curve)
            try container.encode(duration, forKey: .duration)
            try container.encode(extraBounce, forKey: .extraBounce)
        case .interactiveSpring(let duration, let extraBounce):
            try container.encode("interactiveSpring", forKey: .curve)
            try container.encode(duration, forKey: .duration)
            try container.encode(extraBounce, forKey: .extraBounce)
        case .delayed(let animation, let delay):
            try container.encode(delay, forKey: .delay)
            try animation.encode(to: encoder)
        case .repeated(let animation, let repeatCount?, let autoreverses):
            try container.encode(repeatCount, forKey: .repeatCount)
            try container.encode(autoreverses, forKey: .autoreverses)
            try animation.encode(to: encoder)
        case .repeated(let animation, nil, let autoreverses):
            try container.encode(true, forKey: .repeatForever)
            try container.encode(autoreverses, forKey: .autoreverses)
            try animation.encode(to: encoder)
        case .speedModified(let animation, let speed):
            try container.encode(speed, forKey: .speed)
            try animation.encode(to: encoder)
        }
    }
    
    public init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let stringKey = try container.decode(String.self)
            try self.init(key: stringKey)
        } catch {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let curve = try container.decode(String.self, forKey: .curve)
            let duration = try container.decodeIfPresent(Double.self, forKey: .duration)
            let bounce = try container.decodeIfPresent(Double.self, forKey: .bounce)
            let extraBounce = try container.decodeIfPresent(Double.self, forKey: .extraBounce)
            let delay = try container.decodeIfPresent(Double.self, forKey: .delay)
            let repeatCount = try container.decodeIfPresent(Int.self, forKey: .repeatCount)
            let repeatForever = try container.decodeIfPresent(Bool.self, forKey: .repeatForever)
            let autoreverses = try container.decodeIfPresent(Bool.self, forKey: .autoreverses)
            let speed = try container.decodeIfPresent(Double.self, forKey: .speed)
            
            var animation = Animation.default
            
            switch curve {
            case "default":
                break
            case "spring":
                animation = .spring(duration: duration ?? Animation.defaultDuration, bounce: bounce ?? .zero)
            case "smooth":
                animation = .smooth(duration: duration ?? Animation.defaultDuration, extraBounce: extraBounce ?? bounce ?? .zero)
            case "snappy":
                animation = .snappy(duration: duration ?? Animation.defaultDuration, extraBounce: extraBounce ?? bounce ?? .zero)
            case "bouncy":
                animation = .bouncy(duration: duration ?? Animation.defaultDuration, extraBounce: extraBounce ?? bounce ?? .zero)
            case "interactiveSpring":
                animation = .interactiveSpring(duration: duration ?? Animation.defaultDuration, extraBounce: extraBounce ?? bounce ?? .zero)
            default: break
            }
            
            if repeatForever == true, repeatCount == nil {
                animation = animation.repeatForever(autoreverses: autoreverses ?? true)
            }
            
            if let repeatCount {
                animation = animation.repeatCount(repeatCount, autoreverses: autoreverses ?? true)
            }
            
            if let speed {
                animation = animation.speed(speed)
            }
            
            if let delay {
                animation = animation.delayed(delay)
            }
            
            self = animation
        }
    }
    
    private init(key: String) throws {
        guard let match = key.wholeMatch(of: /(?'curve'default|spring|smooth|snappy|bouncy|interactiveSpring)(?:-(?'args'.+))?/)?.output else {
            throw WidgetError.unknownDataType(key)
        }
        
        let args = match.args?.split(separator: "-")
            .compactMap { substring -> (String, Any)? in
                if let match = substring.wholeMatch(of: /(?'duration'[\d.]+)s/)?.output.duration,
                   let duration = Double(match) {
                    return ("duration", duration)
                } else if let match = substring.wholeMatch(of: /d(?'delay'[\d.]+)s/)?.output.delay,
                          let delay = Double(match) {
                    return ("delay", delay)
                } else if let match = substring.wholeMatch(of: /(?'speed'[\d.]+)x/)?.output.speed,
                          let speed = Double(match) {
                    return ("speed", speed)
                } else if let match = substring.wholeMatch(of: /x(?'repeat'\d+)/)?.output.repeat,
                          let repeatCount = Int(match) {
                    return ("repeatCount", repeatCount)
                } else if substring == "forever" {
                    return ("repeatForever", true)
                } else if let match = substring.wholeMatch(of: /(?'key'\w+):(?'value'[^-]+)/)?.output {
                    let value: Any
                    if let double = Double(match.value) {
                        value = double
                    } else if let integer = Int(match.value) {
                        value = integer
                    } else if let boolean = Bool(String(match.value)) {
                        value = boolean
                    } else {
                        value = String(match.value)
                    }
                    return (String(match.key), value)
                } else {
                    return nil
                }
            }
            .toDictionary() ?? [:]
        
        var animation = Animation.default
        
        let duration: TimeInterval = args["duration"] as? Double ?? Animation.defaultDuration
        
        switch match.curve {
        case "default":
            break
        case "spring":
            animation = .spring(duration: duration, bounce: args["bounce"] as? Double ?? .zero)
        case "smooth":
            animation = .smooth(duration: duration, extraBounce: args["extraBounce"] as? Double ?? args["bounce"] as? Double ?? .zero)
        case "snappy":
            animation = .snappy(duration: duration, extraBounce: args["extraBounce"] as? Double ?? args["bounce"] as? Double ?? .zero)
        case "bouncy":
            animation = .bouncy(duration: duration, extraBounce: args["extraBounce"] as? Double ?? args["bounce"] as? Double ?? .zero)
        case "interactiveSpring":
            animation = .interactiveSpring(duration: duration, extraBounce: args["extraBounce"] as? Double ?? args["bounce"] as? Double ?? .zero)
        default: break
        }
        
        let autoreverses = args["autoreverses"] as? Bool
        
        if args["repeatForever"] as? Bool == true, args["repeatCount"] == nil {
            animation = animation.repeatForever(autoreverses: autoreverses ?? true)
        }
        
        if let repeatCount = args["repeatCount"] as? Int {
            animation = animation.repeatCount(repeatCount, autoreverses: autoreverses ?? true)
        }
        
        if let speed = args["speed"] as? Double {
            animation = animation.speed(speed)
        }
        
        if let delay = args["delay"] as? Double {
            animation = animation.delayed(delay)
        }
        
        self = animation
    }
}

#Preview {
    let yaml = """
---
transition: move-top|blur
animation: bouncy-1s-d1s
content: Hello, World!-36-bold
"""
    
    WidgetContainer(yaml: yaml)
}
