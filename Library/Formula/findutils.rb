require 'formula'

class Findutils < Formula
  url 'http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz'
  homepage 'http://www.gnu.org/software/findutils/'
  sha1 'e8dd88fa2cc58abffd0bfc1eddab9020231bb024'

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=g",
                          "--disable-dependency-tracking", "--disable-debug"
    system "make install"
  end
end
