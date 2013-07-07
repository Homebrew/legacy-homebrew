require 'formula'

class DejaGnu < Formula
  homepage 'http://www.gnu.org/software/dejagnu/'
  url 'http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.1.tar.gz'
  sha1 'eb16fb455690592a97f22acd17e8fc2f1b5c54c2'

  head 'git://git.sv.gnu.org/dejagnu.git'

  def install
    ENV.j1 # Or fails on Mac Pro
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to 'make check'
    system "make check"
    system "make install"
  end
end
