//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

let bundle = Bundle.main

func patch(ipa ipaURL: URL, withDebOrDylib debOrDylibURL: URL, andDisplayName displayName: String, andBundleIdentifier bundleIdentifier: String, injectSubstrate: Bool) {
    try? fileManager.removeItem(at: tmp)
    try? fileManager.createDirectory(at: tmp, withIntermediateDirectories: false, attributes: .none)
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
    insertDylibsDir(intoApp: appURL, withDylib: dylibURL, injectSubstrate: injectSubstrate)
    if !patch_binary_with_dylib(binaryURL.path, dylibURL.lastPathComponent, injectSubstrate) {
        fatalExit("无法修补应用 \(binaryURL.path)。二进制文件的格式可能不正确")
    }
    changeDisplayName(ofApp: appURL, to: displayName)
    if !bundleIdentifier.isEmpty {
        changeBundleIdentifier(ofApp: appURL, to: bundleIdentifier)
    }
    saveFile(url: appToIPA(appURL), withPotentialName: displayName, allowedFileTypes: ["ipa"])
}

func insertDylibsDir(intoApp appURL: URL, withDylib dylibURL: URL, injectSubstrate: Bool) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    let newDylibURL = dylibsDir.appendingPathComponent(dylibURL.lastPathComponent)
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    fatalTry("复制动态库文件 \(dylibURL.path) 到应用程序 iPatchDylibs 目录 \(dylibsDir.path) 失败") {
        try fileManager.copyItem(at: dylibURL, to: newDylibURL)
    }
    shell(launchPath: INSTALL_NAME_TOOL, arguments: ["-id", "\(EXECIPATCHDYLIBS)/\(dylibURL.lastPathComponent)", newDylibURL.path])
    if injectSubstrate {
        shell(launchPath: INSTALL_NAME_TOOL, arguments: ["-change", "/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", "\(EXECIPATCHDYLIBS)/libsubstrate.dylib", newDylibURL.path])
        insertSubstrateDylibs(intoApp: appURL)
    }
}

func insertSubstrateDylibs(intoApp appURL: URL) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    fatalTry("无法将 libblackjack、libhooker 和 libsubstrate 复制到应用程序 iPatchDylibs 目录 \(dylibsDir.path)") {
        try fileManager.copyItem(at: bundle.url(forResource: "libblackjack", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libblackjack.dylib"))
        try fileManager.copyItem(at: bundle.url(forResource: "libhooker", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libhooker.dylib"))
        try fileManager.copyItem(at: bundle.url(forResource: "libsubstrate", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libsubstrate.dylib"))
    }
}

func changeDisplayName(ofApp appURL: URL, to displayName: String) {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    info.setValue(displayName, forKey: "CFBundleDisplayName")
    info.write(to: infoURL, atomically: true)
}

func changeBundleIdentifier(ofApp appURL: URL, to bundleIdentifier: String) {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    info.setValue(bundleIdentifier, forKey: "CFBundleIdentifier")
    info.write(to: infoURL, atomically: true)
}
