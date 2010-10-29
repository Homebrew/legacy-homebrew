require 'formula'

class PkgConfig <Formula
  homepage 'http://pkg-config.freedesktop.org'
  url 'http://pkg-config.freedesktop.org/releases/pkg-config-0.25.tar.gz'
  md5 'a3270bab3f4b69b7dc6dbdacbcae9745'

  def install
    paths = %W[
        #{HOMEBREW_PREFIX}/lib/pkgconfig
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
        /usr/X11/lib/pkgconfig
      ].uniq
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-pc-path=#{paths*':'}"
    system "make install"
  end
end