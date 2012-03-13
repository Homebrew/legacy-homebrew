require 'formula'

class Librsync < Formula
  url 'http://downloads.sourceforge.net/project/librsync/librsync/0.9.7/librsync-0.9.7.tar.gz'
  homepage 'http://librsync.sourceforge.net/'
  md5 '24cdb6b78f45e0e83766903fd4f6bc84'

  def patches
    # fixes librsync doesn't correctly export inlined functions:
    # http://trac.macports.org/ticket/31742
    # link to upstream bug report:
    # http://sourceforge.net/tracker/?func=detail&aid=3464437&group_id=56125&atid=479439
    { :p0 => 'https://trac.macports.org/export/90437/trunk/dports/net/librsync/files/patch-delta.c.diff' }
  end

  def install
    ENV.universal_binary
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-shared"

    inreplace 'libtool' do |s|
      s.gsub! /compiler_flags=$/, "compiler_flags=' #{ENV.cflags}'"
      s.gsub! /linker_flags=$/, "linker_flags=' #{ENV.ldflags}'"
    end

    system "make install"
  end
end
