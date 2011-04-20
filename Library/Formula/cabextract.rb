require 'formula'

class Cabextract < Formula
  url 'http://www.cabextract.org.uk/cabextract-1.3.tar.gz'
  homepage 'http://www.cabextract.org.uk/'
  md5 'cb9a4a38470d2a71a0275968e7eb64d3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
