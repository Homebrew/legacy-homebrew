require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.27.tar.gz'
  sha256 '79a6b43ee6633c9e6cc03eb1706370bb7a8450659845b782411f969eaba656a4'

  depends_on 'gettext'

  bottle do
    sha1 '52e1a98740cc834f4b29ee31923812914461f815' => :mountainlion
    sha1 'ebeb434ee288ac7c96cfa09eee98434fe810edff' => :lion
    sha1 'b72a6f5078ee917a28c1e6c9948db23701f4dd18' => :snowleopard
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
        --with-pc-path=#{paths*':'}
        --with-internal-glib
      ]
    args << "CC=#{ENV.cc} #{ENV.cflags}" unless MacOS::CLT.installed?

    system "./configure", *args

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
