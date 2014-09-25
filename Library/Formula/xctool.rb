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
    revision 1
    sha1 "c9939a4a83ab176118117f268df7b539ba63ca94" => :mavericks
    sha1 "93d5006d307d974136ab4022c6cf4d22d7aa70bc" => :mountain_lion
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
