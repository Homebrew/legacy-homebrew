require 'formula'

class Udis86 < Formula
  homepage 'http://udis86.sourceforge.net'
  url 'http://downloads.sourceforge.net/udis86/udis86-1.7.tar.gz'
  md5 'e279108e10f774e6c3af83caa18f5dc3'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
  end
end
