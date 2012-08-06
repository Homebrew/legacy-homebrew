require 'formula'

class Dos2unix < Formula
  homepage 'http://waterlan.home.xs4all.nl/dos2unix.html'
  url 'http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.1.tar.gz'
  sha1 '4f07a16ab3c875cd668e8d9ac3845c6dedce2980'

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
