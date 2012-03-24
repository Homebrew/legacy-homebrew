require 'formula'

class Unixodbc < Formula
  url 'http://www.unixodbc.org/unixODBC-2.3.1.tar.gz'
  homepage 'http://www.unixodbc.org/'
  md5 '86788d4006620fa1f171c13d07fdcaab'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make install"
  end
end
