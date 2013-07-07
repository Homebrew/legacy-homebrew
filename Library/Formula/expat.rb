require 'formula'

class Expat < Formula
  homepage 'http://expat.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz'
  sha1 'b08197d146930a5543a7b99e871cba3da614f6f0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def caveats
    "Note that OS X has Expat 1.5 installed in /usr already."
  end
end
