require 'formula'

class Lft < Formula
  url 'http://pwhois.org/dl/index.who?file=lft-3.1.tar.gz'
  homepage 'http://pwhois.org/lft/'
  sha1 '94a7b1760c099d8d7f19a5f943b8b84e87284a28'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
