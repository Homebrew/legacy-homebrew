require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'https://github.com/downloads/simsong/tcpflow/tcpflow-1.3.0.tar.gz'
  sha1 'fccd0a451bf138e340fc3b55dfc07924c0a811d8'

  depends_on :libtool

  def copy_libtool_files!
<<<<<<< HEAD
<<<<<<< HEAD
    if MacOS.xcode_version >= "4.3"
=======
    if MacOS::Xcode.version >= "4.3"
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
    if not MacOS::Xcode.provides_autotools?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      s = Formula.factory('libtool').share
      d = "#{s}/libtool/config"
      cp ["#{d}/config.guess", "#{d}/config.sub"], "."
<<<<<<< HEAD
    elsif MacOS.leopard?
<<<<<<< HEAD
<<<<<<< HEAD
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
=======
=======
    elsif MacOS.version == :leopard
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config.*"], "."
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config.*"], "."
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
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
