require 'formula'

class Ck < Formula
  url 'http://concurrencykit.org/releases/ck-0.0.2.tar.gz'
  homepage 'http://concurrencykit.org'
  md5 'f799054b075f3a37970dbc8ffc3ffb38'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
