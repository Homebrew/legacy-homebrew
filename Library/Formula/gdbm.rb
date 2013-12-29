require 'formula'

class Gdbm < Formula
  homepage 'http://www.gnu.org/software/gdbm/'
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.11.tar.gz'
  sha1 'ce433d0f192c21d41089458ca5c8294efe9806b4'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
