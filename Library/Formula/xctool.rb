require 'formula'

class Xcode5 < Requirement
  fatal true
  satisfy { MacOS::Xcode.version >= "5.0" }
end

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.15.tar.gz'
  sha1 'bfa6e02ae0fb90294fe653c55e1a7151877319be'
  head 'https://github.com/facebook/xctool.git'

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
