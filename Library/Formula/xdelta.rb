require 'formula'

class Xdelta < Formula
  homepage 'http://xdelta.org'
  url 'http://xdelta.googlecode.com/files/xdelta3-3.0.4.tar.gz'
  sha1 'dee79dbd0632071da0ec53886aa4b72d18cc67ec'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
