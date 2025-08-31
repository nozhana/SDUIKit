//
//  SwiftUIView.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore
import SwiftUI

public struct WidgetContainer: View {
    private let widget: AnyWidget?
    private let error: Error?
    
    public init(widget: any WidgetProtocol) {
        self.widget = .init(widget)
        self.error = nil
    }
    
    public init(json: Data) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public init(json: String) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public var body: some View {
        if let widget {
            AnyWidgetView(widget)
        } else {
            ContentUnavailableView("Failed to parse widget data.", systemImage: "exclamationmark.triangle.fill", description: error.map { Text($0.localizedDescription).foregroundStyle(.secondary) })
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        }
    }
}

#Preview {
    let json = """
{
    "padding": 16,
    "edges": "horizontal",
    "content": {
        "layout": "vertical",
        "spacing": 32,
        "items": [
            {
                "layout": "horizontal",
                "alignment": "top",
                "spacing": 16,
                "items": [
                    {
                        "imageURL": "https://media.istockphoto.com/id/1587604256/photo/portrait-lawyer-and-black-woman-with-tablet-smile-and-happy-in-office-workplace-african.jpg?s=612x612&w=0&k=20&c=n9yulMNKdIYIQC-Qns8agFj6GBDbiKyPRruaUTh4MKs=",
                        "ratio": 1,
                        "resizeMode": "fill"
                    },
                    {
                        "layout": "vertical",
                        "alignment": "leading",
                        "spacing": 12,
                        "items": [
                            {
                                "text": "Jasmine",
                                "properties": {
                                    "fontSize": 24,
                                    "fontWeight": 600
                                }
                            },
                            { "text": "Sr. Product Manager" },
                            {
                                "text": "Codes for \\"fun\\", whatever that means.",
                                "properties": {
                                    "fontSize": 13,
                                    "fontWeight": 300
                                }
                            }
                        ]
                    }
                ]
            },
            {
                "layout": "horizontal",
                "spacing": 32,
                "items": [
                    {
                        "title": { "text": "Talk to Jasmine" },
                        "icon": { "systemImage": "phone.fill" }
                    },
                    {
                        "title": { "text": "Text Jasmine" },
                        "icon": { "systemImage": "message.fill" }
                    }
                ]
            },
        ]
    }
}
"""
    
    WidgetContainer(json: json)
}
