require 'formula'

class Rogue < Formula
  url 'http://rogue.rogueforge.net/files/rogue5.4/rogue5.4.4-src.tar.gz'
  homepage 'http://rogue.rogueforge.net/'
  version '5.4.4'
  sha1 'aef9e589c4f31eb6d3eeb9d543ab8787b00fb022'

  def install
    ENV.ncurses_define if MacOS.snow_leopard?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "config.h", "rogue.scr", "#{var}/rogue/rogue.scr"

    inreplace "Makefile" do |s|
      # Take out weird man install script and DIY below
      s.gsub! "-if test -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(man6dir)/$(PROGRAM).6 ; fi", ""
      s.gsub! "-if test ! -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(mandir)/$(PROGRAM).6 ; fi", ""
    end

    system "make install"
    man6.install gzip("rogue.6")
    libexec.mkdir
  end
end
