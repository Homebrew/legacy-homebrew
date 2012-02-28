require 'formula'

class Dos2unix < Formula
  url 'http://waterlan.home.xs4all.nl/dos2unix/dos2unix-5.3.1.tar.gz'
  md5 '438c48ebd6891b80b58de14c022ca69e'
  homepage 'http://waterlan.home.xs4all.nl/dos2unix.html'

  depends_on "gettext" if ARGV.include? "--enable-nls"

  def options
    [["--enable-nls", "Enable NLS support."]]
  end

  def install
    args = ["prefix=#{prefix}"]

    if ARGV.include? "--enable-nls"
      gettext = Formula.factory("gettext")
      args << "CFLAGS_OS=-I#{gettext.include}"
      args << "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl"
    else
      args << "ENABLE_NLS="
    end

    args << "CC=#{ENV.cc}"
    args << "CPP=#{ENV.cc}"
    args << "CFLAGS=#{ENV.cflags}"
    args << "install"

    system "make", *args
  end
end
