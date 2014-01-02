require 'formula'

class Kismet < Formula
  homepage 'http://www.kismetwireless.net'
  url 'http://www.kismetwireless.net/code/kismet-2011-03-R2.tar.gz'
  version '2011-03-R2'
  sha256 '71a099fb724951cdd55c28e492432ca21657534c91a536c206f3e0a8686d2a64'

  # Strip -rdynamic, per MacPorts
  def patches
    { :p0 => [
      "https://trac.macports.org/export/100624/trunk/dports/net/kismet/files/patch-configure.diff"
    ]}
  end

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
