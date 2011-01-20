require 'formula'

def enable_debug?
  ARGV.include? '--enable-debug'
end

def enable_pop?
  ARGV.include? '--enable-pop'
end

def enable_imap?
  ARGV.include? '--enable-imap'
end

def enable_smtp?
  ARGV.include? '--enable-smtp'
end

def enable_hcache?
  ARGV.include? '--enable-hcache'
end

def with_regex?
  ARGV.include? '--with-regex'
end

def with_tokyocabinet?
  ARGV.include? '--with-tokyocabinet'
end

def with_gdbm?
  ARGV.include? '--with-gdbm'
end

def with_qdbm?
  ARGV.include? '--with-qdbm'
end

def with_gnutls?
  ARGV.include? '--with-gnutls'
end

def with_sasl?
  ARGV.include? '--with-sasl'
end

def with_ssl?
  ARGV.include? '--with-ssl'
end

def with_gss?
  ARGV.include? '--with-gss'
end

# External Patchsets
def sidebar_patch?
  ARGV.include? '--sidebar-patch'
end

def trash_patch?
  ARGV.include? '--trash-patch'
end


class Mutt <Formula
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.20.tar.gz'
  homepage 'http://www.mutt.org/'
  md5 '027cdd9959203de0c3c64149a7ee351c'

  if with_gdbm?
    depends_on 'gdbm'
  elsif with_qdbm?
    depends_on 'qdbm'
  else
    depends_on 'tokyo-cabinet'
  end

  def options
    [
      ['--sidebar-patch', "Apply sidebar (folder list) patch"],
      ['--enable-debug', "Build with debug option enabled"],
      ['--trash-patch', "Apply trash folder patch"]
    ]
  end

  def patches
    # Fix unsubscribe malformed folder
    # See: http://dev.mutt.org/trac/ticket/3389
    p = [ 'http://dev.mutt.org/hg/mutt/raw-rev/25e46aad362b' ]

    # External Patchsets
    if sidebar_patch?
      p << 'http://lunar-linux.org/~tchan/mutt/patch-1.5.20.sidebar.20090619.txt'
    end

    if trash_patch?
      p <<  'http://trac.macports.org/export/69644/trunk/dports/mail/mutt-devel/files/patch-1.5.20.bk.trash_folder-purge_message.1'
    end

    return p
  end

  def install
    args = [ "--disable-dependency-tracking",
             "--disable-warnings",
             "--prefix=#{prefix}",
             # trick 'make install' from trying to chgrp
             "--with-homespool=.mbox" ]

    # Select DB
    if with_gdbm?
      args << "--without-tokyocabinet"
      args << "--with-gdbm"
      args << "--without-qdbm"
    elsif with_qdbm?
      args << "--without-tokyocabinet"
      args << "--without-gdbm"
      args << "--with-qdbm"
    else
      args << "--with-tokyocabinet"
      args << "--without-gdbm"
      args << "--without-qdbm"
    end

    args << "--enable-debug" if enable_debug?
    args << "--enable-pop" if enable_pop?
    args << "--enable-imap" if enable_imap?
    args << "--enable-smtp" if enable_smtp?
    args << "--enable-hcache" if enable_hcache?
    args << "--with-regex" if with_regex?
    args << "--with-gnutls" if with_gnutls?
    args << "--with-sasl" if with_sasl?
    args << "--with-ssl" if with_ssl?
    args << "--with-gss" if with_gss?

    system "./configure", *args
    system "make install"
  end

  def caveats
      if not with_tokyocabinet? and not with_gdbm? and not with_qdbm?
          s = <<-EOS.undent
          Defaulted to tokyocabinet as database, because you didn't specify one.
          EOS
      end
      return s
  end
end
