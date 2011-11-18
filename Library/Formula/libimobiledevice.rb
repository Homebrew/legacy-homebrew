require 'formula'

class Libimobiledevice < Formula
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.1.tar.bz2'
  md5 'cdc13037e822d9ac2e109536701d153a'
  head 'http://cgit.sukimashita.com/libimobiledevice.git', :using => :git
  homepage 'http://www.libimobiledevice.org/'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'glib'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'

  def install
    if ARGV.build_head?
      # fix the m4 problem with the missing pkg.m4
      aclocalDefault = `/usr/bin/aclocal --print-ac-dir`
      inreplace "autogen.sh", "aclocal -I m4", "aclocal -I m4 -I#{aclocalDefault.strip} -I #{HOMEBREW_PREFIX}/share/aclocal"

      ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-swig"
    system "make install"
  end
end
