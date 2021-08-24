//
//  constants.swift
//  iPatch
//
//  Created by Eamon Tracey on 4/8/21.
//

import Foundation

let SUBSTRATEINFOTEXT = "iPatch 支持将 libsubstrate、libblackjack 和 libhooker 注入到 IPA 包中。此功能旨在将 substrate 的 dylib 动态库文件注入到 IPA 包中时使用。如果您正在注入越狱程序插件，请启用此选项。否则，请将其关闭。"
let EXECIPATCHDYLIBS = "@executable_path/iPatchDylibs"

let AR = "/usr/bin/ar"
let TAR = "/usr/bin/tar"
let INSTALL_NAME_TOOL = "/usr/bin/install_name_tool"
let UNZIP = "/usr/bin/unzip"
let ZIP = "/usr/bin/zip"
