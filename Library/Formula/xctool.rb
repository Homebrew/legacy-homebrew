class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/v0.2.6.tar.gz"
  sha256 "8bcec8159c546086672d2c8c2cbda33e0c7b5df04df857ebab7f265b15f65b78"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "56bdde01df4bf32ff13b756dc0b01d478612833dd0cc7a4c2a981ec1f01058be" => :el_capitan
    sha256 "e37b684e801a1298dfe97703ccbfeac0a38b3c71617f34069a5b518c9a8f16db" => :yosemite
    sha256 "ae528a37430f53d9dbdcfa2b028dd47b187f16a5ab3f6f6ef7afbc1a367ab5c2" => :mavericks
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
