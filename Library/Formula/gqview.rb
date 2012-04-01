require 'formula'

class Gqview < Formula
  homepage 'http://gqview.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/gqview/gqview/2.0.4/gqview-2.0.4.tar.gz'
  md5 '7196deab04db94cec2167637cddc02f9'

  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
