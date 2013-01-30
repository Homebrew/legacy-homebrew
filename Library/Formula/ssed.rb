require 'formula'

class Ssed < Formula
  homepage 'http://sed.sourceforge.net/grabbag/ssed/'
  url 'http://sed.sourceforge.net/grabbag/ssed/sed-3.62.tar.gz'
  sha1 '6bdc4cd07780e397787c0d494c962827bb407fa2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make install"
  end
end
