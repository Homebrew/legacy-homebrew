class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.5.1.tar.gz"
  sha256 "629b455724ec47cb7d1277a20bf7dcac997e04b3b2db30213ed17aecce647fed"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "a31e202bac1abae4e8a4b756be92eb106df9061263c22babad469825f4bb388c" => :el_capitan
    sha256 "b045bb9aedb8affb1be853b484c48e1aa47be99e2accb8a65006b15ea96208d1" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    rake "install[#{bin},#{lib}]"

    fixtures = %w[
      UnitTests/fixtures/Images.xcassets
      UnitTests/fixtures/colors.txt
      UnitTests/fixtures/Localizable.strings
      UnitTests/fixtures/Message.storyboard
      UnitTests/expected/Images-File-Defaults.swift.out
      UnitTests/expected/Colors-File-Defaults.swift.out
      UnitTests/expected/Strings-File-Defaults.swift.out
      UnitTests/expected/Storyboards-Message-Defaults.swift.out
    ]
    pkgshare.install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    output = shell_output("#{bin}/swiftgen images #{pkgshare}/Images.xcassets").strip
    assert_equal output, (pkgshare/"Images-File-Defaults.swift.out").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors #{pkgshare}/colors.txt").strip
    assert_equal output, (pkgshare/"Colors-File-Defaults.swift.out").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings #{pkgshare}/Localizable.strings").strip
    assert_equal output, (pkgshare/"Strings-File-Defaults.swift.out").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards #{pkgshare}/Message.storyboard").strip
    assert_equal output, (pkgshare/"Storyboards-Message-Defaults.swift.out").read.strip, "swiftgen storyboards failed"
  end
end
