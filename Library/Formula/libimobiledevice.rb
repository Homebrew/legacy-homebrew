require 'formula'

class Libimobiledevice < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.4.tar.bz2'
  md5 '3f28cbc6a2e30d34685049c0abde5183'

  head 'http://cgit.sukimashita.com/libimobiledevice.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'glib'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    if ARGV.build_head?
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
