class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/v0.2.5.tar.gz"
  sha256 "6135496c3298f69cd5acf350ec5c2b02eca776cf3354b9f83522dfd73e11e367"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
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
