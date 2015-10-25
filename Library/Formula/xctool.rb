class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.2.7.tar.gz"
  sha256 "afbc829f6b9b3f9d45755cd33a8b171def67dd9733977f70a0638d69f4a08730"
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
