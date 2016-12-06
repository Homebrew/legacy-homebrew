require 'formula'

class Tidy <Formula
  homepage 'http://tidy.sf.net/'
  head 'cvs://:pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy:tidy'

  keg_only :provided_by_osx

  def install
    system "sh", "build/gnuauto/setup.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{prefix}/include/tidy",
                          "--disable-dependency-tracking",
                          "--enable-access",
                          "--enable-utf16",
                          "--enable-asian"
    system "make install"
  end
end
