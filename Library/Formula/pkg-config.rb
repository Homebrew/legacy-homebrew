require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.tar.gz'
  sha256 '79a6b43ee6633c9e6cc03eb1706370bb7a8450659845b782411f969eaba656a4'

  depends_on 'gettext'
=======
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.1.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.27.1.tar.gz'
  sha256 '4f63d0df3035101b12949250da5231af49e3c3afcd8fb18554fa7c3cb92d8c17'
=======
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.28.tar.gz'
  sha256 '6b6eb31c6ec4421174578652c7e141fdaae2dabad1021f420d8713206ac1f845'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  bottle do
    sha1 'fe503c105b952d04863931da96f03b0339d7fbb0' => :mountain_lion
    sha1 'd483a4ed0eca160fb5c69d3a0a4011c3393ee2a3' => :lion
    sha1 'e5859bdb284d4810057fd8cace202c60af40885f' => :snow_leopard
  end
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        #{HOMEBREW_PREFIX}/share/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
      ].uniq
<<<<<<< HEAD
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-pc-path=#{paths*':'}",
                          "--with-internal-glib"
=======

    args = %W[
        --disable-debug
        --prefix=#{prefix}
        --disable-host-tool
        --with-internal-glib
        --with-pc-path=#{paths*':'}
      ]
    args << "CC=#{ENV.cc} #{ENV.cflags}" unless MacOS::CLT.installed?

    system "./configure", *args

>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    system "make"
    system "make check"
    system "make install"

    # Fix some bullshit.
    # pkg-config tries to install glib's m4 macros, which will conflict with
    # an actual glib install. See:
    # https://bugs.freedesktop.org/show_bug.cgi?id=52031
    rm Dir["#{share}/aclocal/g*.m4"]
  end
end
