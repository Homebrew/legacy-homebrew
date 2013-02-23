require 'formula'

class Gpp < Formula
  homepage 'http://en.nothingisreal.com/wiki/GPP'
  url 'http://files.nothingisreal.com/software/gpp/gpp-2.24.tar.bz2'
  sha1 '4d79bc151bd16f45494b3719d401d670c4e9d0a4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make check"
    system "make install"
  end
end
