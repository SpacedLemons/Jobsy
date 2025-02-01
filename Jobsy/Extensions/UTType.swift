//
//  UTType.swift
//  Jobsy
//
//  Created by Lucas West on 01/02/2025.
//

import UniformTypeIdentifiers

extension UTType {
    static func safeFromExtension(_ ext: String) -> UTType {
        UTType(filenameExtension: ext) ?? .data
    }

    static var cvTypes: [UTType] {
        [
            .pdf,
            safeFromExtension("doc"),
            safeFromExtension("docx"),
            safeFromExtension("txt"),
            safeFromExtension("rtf"),
            safeFromExtension("pages")
        ]
    }
}
