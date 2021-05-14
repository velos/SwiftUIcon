//
//  main.swift
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import Foundation

let env = ProcessInfo.processInfo.environment

guard let assets = env["SCRIPT_OUTPUT_FILE_0"],
      let deviceFamily = env["TARGETED_DEVICE_FAMILY"],
      let projectPath = env["PROJECT_DIR"],
      let project = env["PROJECT"] else {
    print("error: Missing environment variables, this should have been caught by the build-script.sh")
    exit(1)
}

let macCatalyst = env["SUPPORTS_MACCATALYST"]

var idioms: Set<Idiom> = [.marketing]

if deviceFamily.contains("1") {
    idioms.insert(.iPhone)
}

if deviceFamily.contains("2") {
    idioms.insert(.iPad)
}

if macCatalyst == "YES" {
    idioms.insert(.mac)
}

if #available(OSX 10.15, *) {
    let set = IconSet(idioms: idioms, view: Icon())
    
    try set.write(
        to: URL(fileURLWithPath: assets)
    )
}
