require 'formula'

class Unixodbc < Formula
  @url = 'http://www.unixodbc.org/unixODBC-2.3.0.tar.gz'
  @homepage = 'http://www.unixodbc.org/'
  @md5 = 'f2ad22cbdffe836c58987ed2332c2e99'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-gui=no"
    system "make install"
  end
end
