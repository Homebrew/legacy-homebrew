require 'formula'

class Xcode5 < Requirement
  fatal true
  satisfy { MacOS::Xcode.version >= "5.0" }
end

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.2.1.tar.gz'
  sha1 '49182de7136447f86cfe0c86035a9858befcbbdf'
  head 'https://github.com/facebook/xctool.git'

  bottle do
    sha1 "fcf07aca0621e0b5e7a97e820e49c6a6e05b6901" => :mavericks
    sha1 "62a3b9db0ae8a44580d61e6b2da4fb110d580ea7" => :mountain_lion
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
