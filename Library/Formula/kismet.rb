require 'formula'

class Kismet <Formula
  url 'http://www.kismetwireless.net/code/kismet-2010-01-R1.tar.gz'
  version '2010-01-R1'
  homepage 'http://www.kismetwireless.net'
  md5 'a6d6edcf65d5bb2cb5de6472bcc16f19'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--sysconfdir=#{etc}"

    # Don't chown anything.
    inreplace "Makefile", "-o $(INSTUSR) -g $(INSTGRP)", ""
    inreplace "Makefile", "-o $(INSTUSR) -g $(MANGRP)", ""

    system "make install"
  end

  def caveats
    <<-EOS.undent
      Read #{doc}/README and edit #{etc}/kismet.conf

      Set source=darwin,en1,airport_extreme
      and replace your_user_here in suiduser with your username
    EOS
  end
end
