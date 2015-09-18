class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/v0.2.6.tar.gz"
  sha256 "8bcec8159c546086672d2c8c2cbda33e0c7b5df04df857ebab7f265b15f65b78"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "2dca63fcd23aa73dd802b70998ac22a9d2ff125ca3b96b467dfcbc6fb208aa9d" => :el_capitan
    sha256 "d7b62c48267b2b1e9c660bfe65b1164366f0ebd8ccfbebdc08f5a7cef9dca8a1" => :yosemite
    sha256 "c62eb511deb79f71a8e7a375c5ca493029738d33f890d0395ce8674a7ecb2c1f" => :mavericks
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
