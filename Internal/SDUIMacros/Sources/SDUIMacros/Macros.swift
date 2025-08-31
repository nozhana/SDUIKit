//
//  Macros.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

@attached(extension, conformances: WidgetProtocol, names: arbitrary)
@attached(member, names: named(data), named(init(data:)), named(init()))
public macro WidgetBuilder<Data>(of dataType: Data.Type) = #externalMacro(module: "SDUIMacrosInternal", type: "WidgetBuilderMacro") where Data: Decodable & Sendable

@attached(extension, conformances: WidgetProtocol, names: arbitrary)
@attached(member, names: named(data), named(init(data:)), named(init()))
public macro WidgetBuilder(args: WidgetArgument...) = #externalMacro(module: "SDUIMacrosInternal", type: "WidgetBuilderMacro")
