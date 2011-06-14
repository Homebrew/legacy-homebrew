require 'formula'

class Kismet < Formula
  url 'http://www.kismetwireless.net/code/kismet-2011-03-R1.tar.gz'
  version '2011-03-R1'
  homepage 'http://www.kismetwireless.net'
  sha256 '4bc1ff064dccd65dacdd2db832bc209781daa482690fba444a0b79d36744ff5b'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--sysconfdir=#{etc}"

    # Don't chown anything.
    inreplace "Makefile", "-o $(INSTUSR) -g $(INSTGRP)", ""
    inreplace "Makefile", "-o $(INSTUSR) -g $(MANGRP)", ""

    system "make install"
  end

  def caveats; <<-EOS.undent
    Read http://www.kismetwireless.net/documentation.shtml and edit
      #{etc}/kismet.conf
    as needed.

    * SUID Root functionality does not work, you will have to run this as
      root, e.g. via `sudo`. Do so at your own risk.
    * This version can be configured interactively when it is run (listen
      interface, etc).
    * You may add the line 'ncsource=en1:name=AirPort' to kismet.conf to avoid
      prompting at startup (assuming en1 is your AirPort card).
    EOS
  end
end
