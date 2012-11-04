require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.1.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.27.1.tar.gz'
  sha256 '4f63d0df3035101b12949250da5231af49e3c3afcd8fb18554fa7c3cb92d8c17'

  bottle do
    sha1 '42935c12d2f0496f63bbba4b94c2c02a09035bf0' => :mountainlion
    sha1 'dd791f33f599972d8c95fba908bf8485c46a772d' => :lion
    sha1 '3f1f7c324e277c8774e045ffced8966086c237df' => :snowleopard
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
  end
end
