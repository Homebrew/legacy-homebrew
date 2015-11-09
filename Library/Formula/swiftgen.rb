class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.7.1.tar.gz"
  sha256 "3db3bfef1ed6656afc69129da0a84dccb37ef49a866e175828228ccd607bf054"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "d2b1bceb835510f8d04bdb27bf6011af78df646e5593d645abeb2924b869bde8" => :el_capitan
    sha256 "64d27a4d73cacd6ec4f18d308797494ca4afe32383615328e945891375ebb5b9" => :yosemite
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
