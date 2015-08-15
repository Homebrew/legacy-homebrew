class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.4.4.tar.gz"
  sha256 "429e50b33d1cd3e34fa81b5becff865ce5663284380e91602783bfa109c96b83"
  head "https://github.com/AliSoftware/SwiftGen.git"

  depends_on :xcode => "7.0"

  def install
    ENV["SWIFTGEN_VERSION"] = "#{version} (via Homebrew)"
    rake "install[#{bin},/]"

    pkgshare.install(
      "Tests/Assets/fixtures/Images.xcassets",
      "Tests/Colors/fixtures/colors.txt",
      "Tests/L10n/fixtures/Localizable.strings",
      "Tests/Storyboard/fixtures/Message.storyboard",
      "Tests/Assets/expected/FileDefaults.swift.out" => "assets.swift",
      "Tests/Colors/expected/FileDefaults.swift.out" => "colors.swift",
      "Tests/L10n/expected/FileWithDefaults.swift.out" => "l10n.swift",
      "Tests/Storyboard/expected/MessageWithDefaults.swift.out" => "storyboard.swift",
    )
  end

  test do
    output = shell_output("#{bin}/swiftgen-assets #{pkgshare}/Images.xcassets").strip
    assert_equal output, (pkgshare/"assets.swift").read.strip, "swiftgen-assets failed"

    output = shell_output("#{bin}/swiftgen-colors #{pkgshare}/colors.txt").strip
    assert_equal output, (pkgshare/"colors.swift").read.strip, "swiftgen-colors failed"

    output = shell_output("#{bin}/swiftgen-l10n #{pkgshare}/Localizable.strings").strip
    assert_equal output, (pkgshare/"l10n.swift").read.strip, "swiftgen-l10n failed"

    output = shell_output("#{bin}/swiftgen-storyboard #{pkgshare}/Message.storyboard").strip
    assert_equal output, (pkgshare/"storyboard.swift").read.strip, "swiftgen-storyboard failed"
  end
end
