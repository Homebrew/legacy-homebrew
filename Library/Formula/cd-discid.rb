require 'formula'

class CdDiscid < Formula
  url 'http://linukz.org/download/cd-discid-1.1.tar.gz'
  homepage 'http://linukz.org/cd-discid.shtml'
  sha1 '74cedeb2c5bf4f3248af249c0ff344ea9d713d1a'

  def patches
  { :p0 =>
    "https://trac.macports.org/export/70630/trunk/dports/audio/cd-discid/files/patch-cd-discid.c.diff"
  }
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
