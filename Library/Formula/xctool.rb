class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.2.7.tar.gz"
  sha256 "afbc829f6b9b3f9d45755cd33a8b171def67dd9733977f70a0638d69f4a08730"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "4096a879ff3553b5c07077c3d3797aae526ced093f8235377a8f0e3cd2645f8a" => :el_capitan
    sha256 "5c2033c60a8a1c7fa364ff46e5a6e432207ee0323793ad851cef67b9379aa9c6" => :yosemite
    sha256 "22af6fd008025eb106f775fe44d3ed3afa3e961ee3872c54f26849c2866bcf3b" => :mavericks
  end

  depends_on :xcode => "6.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
