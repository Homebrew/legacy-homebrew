require 'formula'

class Libimobiledevice < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.1.tar.bz2'
  md5 'cdc13037e822d9ac2e109536701d153a'

  head 'http://cgit.sukimashita.com/libimobiledevice.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'glib'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'

  if MacOS.xcode_version >= "4.3" and ARGV.build_head?
    depends_on 'libtool' => :build
    depends_on 'autoconf' => :build
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
                          "--without-swig"
    system "make install"
  end
end
