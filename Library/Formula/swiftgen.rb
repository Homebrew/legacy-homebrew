class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.5.0.tar.gz"
  sha256 "555f190f2ffef940eebd80a926eeb05d3d0de573412028c5bd2184e2b9542929"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6e1ba12afeccbf5e9f8a6961c8dcca93f8342f2f4d0005a0cb6d500a8d06c8f" => :el_capitan
    sha256 "3c17c3c3352543d279044bb2263078d1be7371e94cbbb0ee69f3a837d3108ad2" => :yosemite
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
    system "#{bin}/swiftgen --version"

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
