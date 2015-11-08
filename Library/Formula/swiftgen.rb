class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.7.0.tar.gz"
  sha256 "c1aceb05dea975d23853a24509b62583b8ac6d857ea78c6d36fc61e08881cd14"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "ece8ddf9ea6f4448f057c177d05c302e4a305cb104a7f826751d460453091841" => :el_capitan
    sha256 "0a3fb5ebfefb37a2ec033048e423e2af3f18a8655a27205270ab64c383c1f8b1" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    rake "install[#{bin},#{lib},#{pkgshare}/templates]"

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
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen images -p #{pkgshare/"templates/images-default.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"Images-File-Defaults.swift.out").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors -p #{pkgshare/"templates/colors-default.stencil"} #{fixtures}/colors.txt").strip
    assert_equal output, (fixtures/"Colors-File-Defaults.swift.out").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings -p #{pkgshare/"templates/strings-default.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"Strings-File-Defaults.swift.out").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards -p #{pkgshare/"templates/storyboards-default.stencil"} #{fixtures}/Message.storyboard").strip
    assert_equal output, (fixtures/"Storyboards-Message-Defaults.swift.out").read.strip, "swiftgen storyboards failed"
  end
end
