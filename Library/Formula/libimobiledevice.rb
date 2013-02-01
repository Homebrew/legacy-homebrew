require 'formula'

class Libimobiledevice < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.4.tar.bz2'
  sha1 'd59d9751d9f792e8674cd87c91005d431bf56065'

  head 'http://cgit.sukimashita.com/libimobiledevice.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'glib'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'
  depends_on 'libgcrypt'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
      # fix the m4 problem with the missing pkg.m4
      ENV['LIBTOOLIZE'] = "glibtoolize"
      ENV['ACLOCAL'] = "aclocal -I m4 -I #{HOMEBREW_PREFIX}/share/aclocal"
      ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"

      system "autoreconf -ivf"
    end

    ENV.append_to_cflags "-std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make install"
  end
end
