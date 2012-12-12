require 'formula'

class Trafshow < Formula
  homepage 'http://soft.risp.ru/trafshow/index_en.shtml'
  url 'ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/trafshow-5.2.3.tgz'
  sha1 '1c68f603f12357e932c83de850366c9b46e53d89'

  depends_on :libtool

  def patches
    files = %w[patch-domain_resolver.c patch-colormask.c patch-trafshow.c patch-trafshow.1 patch-configure]
    {
      :p0 =>
      files.collect{|p| "https://trac.macports.org/export/68507/trunk/dports/net/trafshow/files/#{p}"}
    }
  end

  def copy_libtool_files!
    if not MacOS::Xcode.provides_autotools?
      s = Formula.factory('libtool').share
      d = "#{s}/libtool/config"
      cp ["#{d}/config.guess", "#{d}/config.sub"], "."
    elsif MacOS.version == :leopard
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config/config.*"], "."
    end
  end

  def install
    copy_libtool_files!
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-slang"
    system "make"

    bin.install "trafshow"
    man1.install "trafshow.1"
    etc.install ".trafshow" => "trafshow.default"
  end
end
