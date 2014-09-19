require 'formula'

class Xcode5 < Requirement
  fatal true
  satisfy { MacOS::Xcode.version >= "5.0" }
end

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.2.tar.gz'
  sha1 'fb5f5c553ef8ea26a9b68926aa2c59d2d956ee25'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    sha1 "08d8835e3007fccc20559f12bc992f1fe223b74b" => :mavericks
    sha1 "7880ba4ad422d0b93d98db8f336ee83cc08e51a3" => :mountain_lion
  end

  depends_on :xcode
  depends_on Xcode5

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
