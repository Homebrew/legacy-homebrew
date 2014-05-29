require 'formula'

class Xcode5 < Requirement
  fatal true
  satisfy { MacOS::Xcode.version >= "5.0" }
end

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.16.tar.gz'
  sha1 'c4161403b5f742467b37fd41887fde3d99a5989d'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    sha1 "a4a9e31f5356ff9a3923da437c2fb5bf4e8a9495" => :mavericks
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
