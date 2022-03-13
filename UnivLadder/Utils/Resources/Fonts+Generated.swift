// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum Fonts {
  internal enum GmarketSans {
    internal static let bold = FontConvertible(name: "GmarketSansBold", family: "Gmarket Sans", path: "GmarketSansBold.otf")
    internal static let light = FontConvertible(name: "GmarketSansLight", family: "Gmarket Sans", path: "GmarketSansLight.otf")
    internal static let medium = FontConvertible(name: "GmarketSansMedium", family: "Gmarket Sans", path: "GmarketSansMedium.otf")
    internal static let all: [FontConvertible] = [bold, light, medium]
  }
  internal enum EsamanruOTF {
    internal static let bold = FontConvertible(name: "esamanruOTFBold", family: "esamanru OTF", path: "esamanruOTFBold.otf")
    internal static let light = FontConvertible(name: "esamanruOTFLight", family: "esamanru OTF", path: "esamanruOTFLight.otf")
    internal static let medium = FontConvertible(name: "esamanruOTFMedium", family: "esamanru OTF", path: "esamanruOTFMedium.otf")
    internal static let all: [FontConvertible] = [bold, light, medium]
  }
  internal static let allCustomFonts: [FontConvertible] = [GmarketSans.all, EsamanruOTF.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
