require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.30.tar.bz2'
  mirror 'http://downloads.sourceforge.net/project/pcre/pcre/8.30/pcre-8.30.tar.bz2'
  md5 '98e8928cccc945d04279581e778fbdff'

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2"
    system "make test"
    system "make install"
  end
end
