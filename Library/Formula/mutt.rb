require 'brewkit'

class Mutt <Formula
  @url='ftp://ftp.mutt.org/mutt/devel/mutt-1.5.20.tar.gz'
  @homepage='http://www.mutt.org/'
  @md5='027cdd9959203de0c3c64149a7ee351c'

  def install
      configure_args = [
          "--prefix=#{prefix}",
          "--disable-debug",
          "--disable-dependency-tracking",
          "--disable-warnings",
          "--with-ssl",
          "--with-sasl",
          "--with-gnutls",
          "--with-gss",
          "--enable-imap",
          "--enable-smtp",
          "--enable-pop",

          # This is just a trick to keep 'make install' from trying to chgrp
          # the mutt_dotlock file (which we can't do if we're running as an
          # unpriviledged user)
          "--with-homespool=.mbox"
      ]

    system "./configure", *configure_args
    system "make install"
  end
end
