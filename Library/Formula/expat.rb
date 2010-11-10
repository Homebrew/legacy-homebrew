require 'formula'

class Expat <Formula
  url 'http://downloads.sourceforge.net/project/expat/expat/2.0.1/expat-2.0.1.tar.gz'
  homepage 'http://expat.sourceforge.net/'
  md5 'ee8b492592568805593f81f8cdf2a04c'

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
