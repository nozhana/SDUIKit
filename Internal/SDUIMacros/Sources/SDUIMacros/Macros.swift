//
//  Macros.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

@attached(extension, conformances: WidgetProtocol, names: arbitrary)
@attached(member, names: named(data), named(init(data:)))
public macro WidgetBuilder<Data>(of dataType: Data.Type, args: Argument...) = #externalMacro(module: "SDUIMacrosInternal", type: "WidgetBuilderMacro")

@attached(extension, conformances: WidgetProtocol, names: arbitrary)
@attached(member, names: named(data), named(init(data:)))
public macro WidgetBuilder(args: Argument...) = #externalMacro(module: "SDUIMacrosInternal", type: "WidgetBuilderMacro")
