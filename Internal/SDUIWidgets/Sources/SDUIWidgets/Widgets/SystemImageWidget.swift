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
    public struct Data: Decodable, Sendable {
        public var name: String
        public var resizeMode: ResizeMode?
        
        public enum CodingKeys: String, CodingKey {
            case name = "systemImage"
            case resizeMode
        }
        
        public init(from decoder: any Decoder) throws {
            do {
                let container = try decoder.container(keyedBy: SystemImageWidget.Data.CodingKeys.self)
                self.name = try container.decode(String.self, forKey: SystemImageWidget.Data.CodingKeys.name)
                self.resizeMode = try container.decodeIfPresent(ResizeMode.self, forKey: SystemImageWidget.Data.CodingKeys.resizeMode)
            } catch {
                let container = try decoder.singleValueContainer()
                let stringKey = try container.decode(String.self)
                guard stringKey.starts(with: /icon-/) else {
                    throw WidgetError.unknownDataType(stringKey)
                }
                let iconKey = String(stringKey.dropFirst(5))
                self.name = iconKey
                self.resizeMode = nil
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
