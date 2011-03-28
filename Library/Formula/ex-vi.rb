require 'formula'

class ExVi < Formula
  url 'http://sourceforge.net/projects/ex-vi/files/ex-vi/050325/ex-050325.tar.bz2'
  homepage 'http://ex-vi.sourceforge.net/'
  md5 'e668595254233e4d96811083a3e4e2f3'

  def install
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end
