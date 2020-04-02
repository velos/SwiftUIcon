//
//  generate.swift
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import Foundation

let env = ProcessInfo.processInfo.environment

guard let deviceFamily = env["TARGETED_DEVICE_FAMILY"],
    let projectPath = env["PROJECT_DIR"],
    let project = env["PROJECT"] else {
        exit(1)
}

var idioms: Set<Idiom> = [.marketing]

if deviceFamily.contains("1") {
    idioms.insert(.iPhone)
}

if deviceFamily.contains("2") {
    idioms.insert(.iPad)
}

idioms.insert(.marketing)

let set = IconSet(idioms: idioms, view: Icon())
try! set.write(
    to: URL(fileURLWithPath: projectPath)
        .appendingPathComponent(project)
        .appendingPathComponent("Assets.xcassets")
)
