require 'formula'

class Scrub < Formula
  url 'http://diskscrub.googlecode.com/files/scrub-2.4.tar.bz2'
  homepage 'http://code.google.com/p/diskscrub/'
  md5 '653b9698a7e62fd0c22704e1d6a3469c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
