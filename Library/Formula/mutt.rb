require 'formula'

class Mutt <Formula
  @url='ftp://ftp.mutt.org/mutt/devel/mutt-1.5.20.tar.gz'
  @homepage='http://www.mutt.org/'
  @md5='027cdd9959203de0c3c64149a7ee351c'
  
  depends_on 'tokyo-cabinet'

  def options
    [
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--trash-patch', "Apply trash folder patch"]
    ]
  end

  def patches
    patches = []
    if ARGV.include? '--sidebar-patch'
      patches << 'http://lunar-linux.org/~tchan/mutt/patch-1.5.20.sidebar.20090619.txt'
    end
    if ARGV.include? '--trash-patch'
      patches << 'http://trac.macports.org/raw-attachment/ticket/20412/patch-1.5.20.cd.trash_folder.diff'
    end
    patches
  end

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
          "--enable-hcache",

          # This is just a trick to keep 'make install' from trying to chgrp
          # the mutt_dotlock file (which we can't do if we're running as an
          # unpriviledged user)
          "--with-homespool=.mbox"
      ]

    system "./configure", *configure_args
    system "make install"
  end
end
