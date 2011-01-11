require 'formula'

class Mutt <Formula
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.20.tar.gz'
  homepage 'http://www.mutt.org/'
  md5 '027cdd9959203de0c3c64149a7ee351c'

  depends_on 'tokyo-cabinet'

  def options
    [
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--trash-patch', "Apply trash folder patch"],
      ['--enable-debug', "Build with debug option -d enabled"],
    ]
  end

  def patches
    p = []

    if ARGV.include? '--sidebar-patch'
      p << 'http://lunar-linux.org/~tchan/mutt/patch-1.5.20.sidebar.20090619.txt'
    end

    if ARGV.include? '--trash-patch'
      p <<  'http://trac.macports.org/export/69644/trunk/dports/mail/mutt-devel/files/patch-1.5.20.bk.trash_folder-purge_message.1'
    end

    return p
  end

  def install
    args = [
        "--disable-dependency-tracking",
        "--disable-warnings",
        "--prefix=#{prefix}",
        "--with-ssl",
        "--with-sasl",
        "--with-gnutls",
        "--with-gss",
        "--enable-imap",
        "--enable-smtp",
        "--enable-pop",
        "--enable-hcache",
        "--with-tokyocabinet",
        # This is just a trick to keep 'make install' from trying to chgrp
        # the mutt_dotlock file (which we can't do if we're running as an
        # unpriviledged user)
        "--with-homespool=.mbox",
    ]
    args << "--enable-debug" if ARGV.include? "--enable-debug"
    system "./configure", *args
    system "make install"
  end
end
