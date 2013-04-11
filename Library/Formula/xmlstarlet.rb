require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://sourceforge.net/projects/xmlstar/files/xmlstarlet/1.4.2/xmlstarlet-1.4.2.tar.gz'
  sha1 '432bd1bd2511369b7823e5731397744435a68f04'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
    ln_s bin/'xml', bin/'xmlstarlet'
  end
end
