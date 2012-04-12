require 'formula'

class Nettle < Formula
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.4.tar.gz'
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  md5 '450be8c4886d46c09f49f568ad6fa013'

  depends_on 'gmp'

  def patches
    # patch from MacPorts to sort out really ugly dylib mess
    { :p0 => "https://trac.macports.org/export/85828/trunk/dports/devel/nettle/files/patch-configure.diff" }
  end

  def install
    ENV.universal_binary
    ENV['DYLD_LIBRARY_PATH'] = lib # otherwise 'make check' fails

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-assembler"
    system "make"
    system "make install"
    system "make check"
  end
end
