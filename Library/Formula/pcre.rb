require 'formula'

class Pcre <Formula
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.11.tar.bz2'
  homepage 'http://www.pcre.org/'
  md5 'ef907b8792ec7f90f0dcd773848f0b3b'

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
