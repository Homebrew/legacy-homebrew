require 'formula'

class Libfreefare < Formula
  homepage 'https://code.google.com/p/libfreefare/'
  url 'https://libfreefare.googlecode.com/files/libfreefare-0.4.0.tar.bz2'
  sha1 '74214069d6443a6a40d717e496320428a114198c'

  depends_on 'pkg-config' => :build
  depends_on 'libnfc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
