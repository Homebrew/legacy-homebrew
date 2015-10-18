class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.5.0.tar.gz"
  sha256 "555f190f2ffef940eebd80a926eeb05d3d0de573412028c5bd2184e2b9542929"
  head "https://github.com/AliSoftware/SwiftGen.git"
  revision 1

  bottle do
    cellar :any
    sha256 "2720dec00532d078ac959fd65f05ddf3cc2a0837f383e5e32d1d0a423527f4ae" => :el_capitan
    sha256 "ebedd73315bbe82499e3add958fbabbf6da70861d034793b416761f187460912" => :yosemite
  end

  def pour_bottle?
    # The binary's @rpath points to Xcode.app internal dylibs, so using a bottle won't work if the user doesn't
    # have an Xcode installed in /Applications/Xcode.app (= the path used when BrewBot built the bottle)
    Pathname.new("/Applications/Xcode.app").exist?
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
