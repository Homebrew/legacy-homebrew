require 'formula'

class Duff < Formula
  url 'http://downloads.sourceforge.net/duff/duff-0.4.tar.bz2'
  homepage 'http://duff.sourceforge.net/'
  md5 '9767e471232c1b4ee553ae40dbe60464'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    # this needs to be executable, but isn't for some reason...
    system "chmod 755 ./install-sh"
    system "make install"
  end
end
