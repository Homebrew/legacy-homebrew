require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.5.0/xmlstarlet-1.5.0.tar.gz'
  sha1 '1490f93fa04ee9636a5879e441a9d29dd63229f1'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
    ln_s bin/'xml', bin/'xmlstarlet'
  end
end
