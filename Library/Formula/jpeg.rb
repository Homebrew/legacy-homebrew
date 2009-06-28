require 'brewkit'

class Jpeg <Formula
  @url='http://www.ijg.org/files/jpegsrc.v6b.tar.gz'
  @md5='dbd5f3b47ed13132f04c685d608a7547'
  @homepage='http://www.ijg.org'

  def initialize name
    super name
    # the jpeg group have one crazy ass naming scheme
    @version='6b'
  end

  def install
    # --mandir='#{man}' doesn't do anything
    system "./configure --disable-debug --prefix='#{prefix}'"

    # cope with braindead install system
    (prefix+'man'+'man1').mkpath
    bin.mkpath
    include.mkpath
    lib.mkpath
    # this package is shit
    inreplace 'Makefile', 'LIBTOOL = ./libtool', 'LIBTOOL = /usr/bin/libtool'

    system "make install install-lib install-headers"
    # fix manpages
    (prefix+'man').mv prefix+'share'
  end
end