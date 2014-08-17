require 'formula'

class Lft < Formula
  homepage 'http://pwhois.org/lft/'
  url 'http://pwhois.org/dl/index.who?file=lft-3.36.tar.gz'
  sha1 'f70a35b8340c1e0ff2a3435ec982e16bca3a0413'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
