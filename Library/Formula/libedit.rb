require 'formula'

class Libedit < Formula
  homepage 'http://www.thrysoee.dk/editline/'
  url 'http://www.thrysoee.dk/editline/libedit-20120601-3.0.tar.gz'
  version '20120601-3'
  sha1 '18ec27120f6abb222754e9f283d000fec0dcfc08'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
