//
//  DownCommonMarkRenderable.swift
//  Down
//
//  Created by Rob Phillips on 5/31/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation
import libcmark

public protocol DownCommonMarkRenderable: DownRenderable {
    /**
     Generates a CommonMark Markdown string from the `markdownString` property

     - parameter options: `DownOptions` to modify parsing or rendering
     - parameter width:   The width to break on

     - throws: `DownErrors` depending on the scenario

     - returns: CommonMark Markdown string
     */
    @warn_unused_result
    func toCommonMark(options: DownOptions, width: Int32) throws -> String
}

public extension DownCommonMarkRenderable {
    /**
     Generates a CommonMark Markdown string from the `markdownString` property

     - parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.Default`
     - parameter width:   The width to break on, defaulting to 0

     - throws: `DownErrors` depending on the scenario

     - returns: CommonMark Markdown string
     */
    @warn_unused_result
    public func toCommonMark(options: DownOptions = .Default, width: Int32 = 0) throws -> String {
        let ast = try DownASTRenderer.stringToAST(markdownString, options: options)
        let commonMark = try DownCommonMarkRenderer.astToCommonMark(ast, options: options, width: width)
        cmark_node_free(ast)
        return commonMark
    }
}

public struct DownCommonMarkRenderer {
    /**
     Generates a CommonMark Markdown string from the given abstract syntax tree
     
     **Note:** caller is responsible for calling `cmark_node_free(ast)` after this returns

     - parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.Default`
     - parameter width:   The width to break on, defaulting to 0

     - throws: `ASTRenderingError` if the AST could not be converted

     - returns: CommonMark Markdown string
     */
    @warn_unused_result
    public static func astToCommonMark(ast: UnsafeMutablePointer<cmark_node>,
                                       options: DownOptions = .Default,
                                       width: Int32 = 0) throws -> String {
        let cCommonMarkString = cmark_render_commonmark(ast, options.rawValue, width)
        let outputString = String(CString: cCommonMarkString, encoding: NSUTF8StringEncoding)

        free(cCommonMarkString)

        guard let commonMarkString = outputString else {
            throw DownErrors.ASTRenderingError
        }
        return commonMarkString
    }
}