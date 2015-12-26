class Libexif < Formula
  desc "EXIF parsing library"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz"
  sha256 "edb7eb13664cf950a6edd132b75e99afe61c5effe2f16494e6d27bc404b287bf"

  bottle do
    cellar :any
    revision 1
    sha256 "5990278735f835e2ab004ceac83616a3a71f6ae96c6f5eb0c0f1aa2af0452fb6" => :el_capitan
    sha256 "cebb385c6f48fafa10b8731daec8ce38d8ee34ff7d3afc131edd553a2249662f" => :yosemite
    sha256 "791e4c2073051f5e93fee0f30d1888f39b2873eacbfadbc4b3dd6328b80dfb51" => :mavericks
    sha256 "c84d39e0e1b14770c53190e46aa80ed4155dc22106a104d11fe4c85e533bf1ba" => :mountain_lion
  end

  fails_with :llvm do
    build 2334
    cause "segfault with llvm"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
