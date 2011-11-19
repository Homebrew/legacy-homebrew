require 'formula'

class Pcre < Formula
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.20.tar.bz2'
  homepage 'http://www.pcre.org/'
  md5 'a1931c70e1273e3450d5036fe273d25c'

  fails_with_llvm "Bus error in ld on SL 10.6.4", :build => 2326

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
