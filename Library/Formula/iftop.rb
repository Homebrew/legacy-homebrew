require 'formula'

class Iftop < Formula
  url 'http://www.ex-parrot.com/~pdw/iftop/download/iftop-0.17.tar.gz'
  homepage 'http://www.ex-parrot.com/~pdw/iftop/'
  sha1 '75ce6afc8c0bf851278b0a15e66f523af90cfda9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
