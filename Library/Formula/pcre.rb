require 'formula'

class Pcre <Formula
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.10.tar.bz2'
  homepage 'http://www.pcre.org/'
  md5 '780867a700e9d4e4b9cb47aa5453e4b2'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    fails_with_llvm "Bus error in ld on SL 10.6.4"
    ENV.universal_binary if ARGV.include? "--universal"

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
