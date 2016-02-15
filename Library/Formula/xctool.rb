class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.2.8.tar.gz"
  sha256 "0f0bb2f39cf5794ce53f2e7944e2893f30899c54f7d2726ae72e707b6fc1262c"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "be435da1dfb833642a112e25b767e793f9f686110fb8efc0377bda285d4f1b97" => :el_capitan
    sha256 "04714b680777556b4c0c45a635267b35beb27d4e6fb0a8e767b1edb7f047c294" => :yosemite
    sha256 "967031550240000fc4989fd8976254873efd184f4f9ac5ea946a1221cda1e2b6" => :mavericks
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
