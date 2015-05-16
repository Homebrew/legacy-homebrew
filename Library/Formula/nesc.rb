require 'formula'

class Nesc < Formula
  homepage 'http://nescc.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/nescc/nescc/v1.3.4/nesc-1.3.4.tar.gz'
  sha1 '360148ca99a88b628bcd4490ad42a9466490bf4e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
