require 'formula'

class Expat < Formula
  url 'http://downloads.sourceforge.net/project/expat/expat/2.0.1/expat-2.0.1.tar.gz'
  homepage 'http://expat.sourceforge.net/'
  sha1 '663548c37b996082db1f2f2c32af060d7aa15c2d'

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
