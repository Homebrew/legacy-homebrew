require 'formula'

class Unixodbc < Formula
  homepage 'http://www.unixodbc.org/'
  url 'http://www.unixodbc.org/unixODBC-2.3.1.tar.gz'
  sha1 '815cbc4f34e1a6d95daf3a5ab74e6ed3a586aad7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make install"
  end
end
