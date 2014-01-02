require 'formula'

class Udis86 < Formula
  homepage 'http://udis86.sourceforge.net'
  url 'http://downloads.sourceforge.net/udis86/udis86-1.7.2.tar.gz'
  sha1 'f55dec2d5319aac9d0a7ae2614ddcc7aa73d3744'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
  end
end
