require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.28.tar.gz'
  sha256 '6b6eb31c6ec4421174578652c7e141fdaae2dabad1021f420d8713206ac1f845'

  bottle do
    sha1 'fe503c105b952d04863931da96f03b0339d7fbb0' => :mountain_lion
    sha1 'd483a4ed0eca160fb5c69d3a0a4011c3393ee2a3' => :lion
    sha1 'e5859bdb284d4810057fd8cace202c60af40885f' => :snow_leopard
  end

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        #{HOMEBREW_PREFIX}/share/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
      ].uniq

    args = %W[
        --disable-debug
        --prefix=#{prefix}
        --disable-host-tool
        --with-internal-glib
        --with-pc-path=#{paths*':'}
      ]
    args << "CC=#{ENV.cc} #{ENV.cflags}" unless MacOS::CLT.installed?

    system "./configure", *args

    system "make"
    system "make check"
    system "make install"
  end
end
