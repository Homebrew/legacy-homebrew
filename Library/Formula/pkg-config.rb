require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'

  # yes we know pkg-config 0.26 is now out, however it depends on glib
  # this is totally ridiculous dependency and we refuse to upgrade until
  # someone can prove we must.
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.25.tar.gz'
  md5 'a3270bab3f4b69b7dc6dbdacbcae9745'

  def install
    # fixes compile error on Lion with Clang duplicate symbols in libglib
    ENV.append_to_cflags '-std=gnu89' if ENV.compiler == :clang

    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        #{HOMEBREW_PREFIX}/share/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
      ].uniq
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-pc-path=#{paths*':'}"
    system "make"
    system "make check"
    system "make install"
  end
end
