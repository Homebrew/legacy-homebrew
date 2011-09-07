require 'formula'

class Ssed < Formula
  url 'http://sed.sourceforge.net/grabbag/ssed/sed-3.62.tar.gz'
  homepage 'http://sed.sourceforge.net/grabbag/ssed/'
  md5 '8f35882af95da4e5ddbf3de1add26f79'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make install"
  end
end
