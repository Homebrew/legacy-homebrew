require 'formula'

class Ngspice < Formula
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/22/ngspice-22.tar.gz'
  homepage 'http://ngspice.sourceforge.net/'
  md5 'b55cdd80a56692fe6ce13f7a33c64d08'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-editline=yes",
                          "--enable-x"
    system "make install"
  end

  def caveats
    "Note: ngspice is an X11 application."
  end
end
