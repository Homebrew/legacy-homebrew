class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/0.7.3.tar.gz"
  sha256 "800018a48379e5401dd89e6f6bbfe93884bd796d007eaf5ff2307b18419434d6"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "bbd49dbdd07a9f139e8399e2c32a78721001aa1ddce56682fe1b729ca86b4fb9" => :el_capitan
    sha256 "c1fd5c0160b0d04650840fab9f49841ccd9b2d84c8c6bfc9d14abc4e866d4515" => :yosemite
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

    output = shell_output("#{bin}/swiftgen images --templatePath #{pkgshare/"templates/images-default.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"Images-File-Defaults.swift.out").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors-default.stencil"} #{fixtures}/colors.txt").strip
    assert_equal output, (fixtures/"Colors-File-Defaults.swift.out").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings-default.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"Strings-File-Defaults.swift.out").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards-default.stencil"} #{fixtures}/Message.storyboard").strip
    assert_equal output, (fixtures/"Storyboards-Message-Defaults.swift.out").read.strip, "swiftgen storyboards failed"
  end
end
