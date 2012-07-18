require 'formula'

class Mutt < Formula
  homepage 'http://www.mutt.org/'
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  md5 'a29db8f1d51e2f10c070bf88e8a553fd'

  depends_on 'tokyo-cabinet'
  depends_on 'slang' if ARGV.include? '--with-slang'

  def options
    [
      ['--enable-debug', "Build with debug option enabled"],
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--trash-patch', "Apply trash folder patch"],
      ['--with-slang', "Build against slang instead of ncurses"],
      ['--ignore-thread-patch', "Apply ignore-thread patch"],
      ['--pgp-verbose-mime-patch', "Apply PGP verbose mime patch"]
    ]
  end

  def patches
    urls = [
      ['--sidebar-patch', 'https://raw.github.com/nedos/mutt-sidebar-patch/master/mutt-sidebar.patch'],
      ['--trash-patch', 'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.1/features/trash-folder'],
      ['--ignore-thread-patch', 'http://ben.at.tanjero.com/patches/ignore-thread-1.5.21.patch'],
      ['--pgp-verbose-mime-patch',
          'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.1/features-old/patch-1.5.4.vk.pgp_verbose_mime'],
    ]

    p = []
    urls.each do |u|
      p << u[1] if ARGV.include? u[0]
    end
    return p
  end

  def install
    args = ["--disable-dependency-tracking",
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
            "--with-homespool=.mbox"]
    args << "--with-slang" if ARGV.include? '--with-slang'

    if ARGV.include? '--enable-debug'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end
end
