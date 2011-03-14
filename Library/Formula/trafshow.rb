require 'formula'

class Trafshow < Formula
  url 'ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/trafshow-5.2.3.tgz'
  homepage 'http://soft.risp.ru/trafshow/index_en.shtml'
  md5 '0b2f0bb23b7832138b7d841437b9e182'

  def patches
    files = %w[patch-domain_resolver.c patch-colormask.c patch-trafshow.c patch-trafshow.1 patch-configure]
    {
      :p0 =>
      files.collect{|p| "http://trac.macports.org/export/68507/trunk/dports/net/trafshow/files/#{p}"}
    }
  end

  def install
    # Per MacPorts, to detect OS X as the system
    system "cp /usr/share/libtool/config/config.* ."
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-slang"
    system "make"

    bin.install "trafshow"
    man1.install "trafshow.1"
    etc.install ".trafshow" => "trafshow.default"
  end
end
