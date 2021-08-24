//
//  dependencies.swift
//  iPatch
//
//  Created by Eamon Tracey on 4/8/21.
//

func validateDependencies() {
    if !fileManager.filesExist(atFileURLS: [URL(fileURLWithPath: AR), URL(fileURLWithPath: TAR), URL(fileURLWithPath: INSTALL_NAME_TOOL), URL(fileURLWithPath: UNZIP), URL(fileURLWithPath: ZIP)]) {
        fatalExit("缺少依赖项。请确保已安装 Xcode 命令行工具。iPatch 需要 \(AR), \(TAR), \(INSTALL_NAME_TOOL), \(UNZIP), and \(ZIP)")
    }
}
