class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.4.1.tar.gz"
  sha256 "d5009662756a2491528b7099c0d68146b8546e46b8ab3d9d1196127464f3567e"
  head "https://github.com/AliSoftware/SwiftGen.git"

  def install
    # Install all the binaries
    ENV["SWIFTGEN_VERSION"] = "#{version} (via Homebrew)"
    rake "install[#{bin},/]"

    # Install the various test fixtures in pkgshare needed for `brew test`
    pkgshare.install(
      "Tests/Assets/fixtures/Images.xcassets" => "Images.xcassets",
      "Tests/Assets/expected/FileDefaults.swift.out" => "assets.swift",
      "Tests/Colors/fixtures/colors.txt" => "colors.txt",
      "Tests/Colors/expected/FileDefaults.swift.out" => "colors.swift",
      "Tests/L10n/fixtures/Localizable.strings" => "Localizable.strings",
      "Tests/L10n/expected/FileWithDefaults.swift.out" => "l10n.swift",
      "Tests/Storyboard/fixtures/Message.storyboard" => "Message.storyboard",
      "Tests/Storyboard/expected/MessageWithDefaults.swift.out" => "storyboard.swift"
    )
  end

  test do
    output = `#{bin}/swiftgen-assets #{pkgshare}/Images.xcassets`.strip
    assert_equal output, (pkgshare/"assets.swift").read.strip, "swiftgen-assets failed"

    output = `#{bin}/swiftgen-colors #{pkgshare}/colors.txt`.strip
    assert_equal output, (pkgshare/"colors.swift").read.strip, "swiftgen-colors failed"

    output = `#{bin}/swiftgen-l10n #{pkgshare}/Localizable.strings`.strip
    assert_equal output, (pkgshare/"l10n.swift").read.strip, "swiftgen-l10n failed"

    output = `#{bin}/swiftgen-storyboard #{pkgshare}/Message.storyboard`.strip
    assert_equal output, (pkgshare/"storyboard.swift").read.strip, "swiftgen-storyboard failed"
  end
end
