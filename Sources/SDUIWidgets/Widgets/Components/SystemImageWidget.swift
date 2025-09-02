//
//  SystemImageWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIUtilities
import SwiftUI

public struct SystemImageWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        Image(systemName: data.name)
            .ifLet(data.resizeMode) { content, unwrapped in
                content
                    .resizable()
                    .aspectRatio(contentMode: unwrapped.systemContentMode)
            }
    }
}

extension SystemImageWidget {
    public struct Data: Codable, Sendable {
        public var name: String
        public var resizeMode: ResizeMode?
        
        public enum CodingKeys: String, CodingKey {
            case name = "systemImage"
            case resizeMode
        }
        
        public init(from decoder: any Decoder) throws {
            do {
                let container = try decoder.singleValueContainer()
                let stringKey = try container.decode(String.self)
                guard let components = stringKey.wholeMatch(of: /icon-(.+)/)?.output.1
                    .split(separator: "-", omittingEmptySubsequences: false)
                    .map(String.init),
                      let name = components.first else {
                    throw WidgetError.unknownDataType(stringKey)
                }
                self.name = name
                self.resizeMode = components[safe: 1].map { ResizeMode(rawValue: $0) } ?? nil
            } catch {
                let container = try decoder.container(keyedBy: SystemImageWidget.Data.CodingKeys.self)
                self.name = try container.decode(String.self, forKey: SystemImageWidget.Data.CodingKeys.name)
                self.resizeMode = try container.decodeIfPresent(ResizeMode.self, forKey: SystemImageWidget.Data.CodingKeys.resizeMode)
            }
        }
        
        public init(name: String, resizeMode: ResizeMode? = nil) {
            self.name = name
            self.resizeMode = resizeMode
        }
    }
}

#Preview {
    SystemImageWidget(data: .init(name: "party.popper.fill"))
}
