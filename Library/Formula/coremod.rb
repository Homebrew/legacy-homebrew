require "formula"

class Coremod < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://github.com/cmatsuoka/coremod/archive/coremod-4.2.0.tar.gz"
  sha1 "3dc36af9fef89ad5204554440a7044a5ceaf3f67"

  head do
    url "https://github.com/cmatsuoka/coremod.git"
  end

  depends_on :autoconf

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
