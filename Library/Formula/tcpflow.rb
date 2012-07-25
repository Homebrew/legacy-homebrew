require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'https://github.com/downloads/simsong/tcpflow/tcpflow-1.2.7.tar.gz'
  sha1 'e7e71a34afb4d557ebe80e2d589f00d4afd38be4'

  def copy_libtool_files!
    if MacOS::Xcode.version >= "4.3"
      s = Formula.factory('libtool').share
      d = "#{s}/libtool/config"
      cp ["#{d}/config.guess", "#{d}/config.sub"], "."
    elsif MacOS.leopard?
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config/config.*"], "."
    end
  end

  def install
    copy_libtool_files!
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
