require 'formula'

class Libfreefare < Formula
  homepage 'https://code.google.com/p/libfreefare/'
  url 'https://libfreefare.googlecode.com/files/libfreefare-0.4.0.tar.bz2'
  sha1 '74214069d6443a6a40d717e496320428a114198c'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "5939f87b737816272e8bd24bf54ceabcedd9eac6" => :yosemite
    sha1 "1890623e36354d249e06587ff9eaaa0af8ee8ded" => :mavericks
    sha1 "ab6743edaf802a89944cec742d0c2b1f193d7897" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libnfc'
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
