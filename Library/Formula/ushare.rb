require 'formula'

class Ushare < Formula
  url 'http://ushare.geexbox.org/releases/ushare-1.1a.tar.bz2'
  homepage 'http://ushare.geexbox.org/'
  md5 '5bbcdbf1ff85a9710fa3d4e82ccaa251'

  depends_on 'gettext'
  depends_on 'libupnp'
  depends_on 'libdlna'

  def patches
    { :p0 =>
      "http://svn.macports.org/repository/macports/trunk/dports/net/ushare/files/patch-configure.diff",
      # applies some modifications to keep with up to date libupnp (should be upstream I guess)
      :p1 =>
      "http://dev.openwrt.org/browser/packages/multimedia/ushare/patches/200-compile-fixes.patch?format=txt"
    }
  end

  def install
    # Need to explicitly add gettext here.
    gettext = Formula.factory("gettext")
    ENV.append 'LDFLAGS', "-lintl"
    ENV.append 'CFLAGS', "-I#{gettext.include}"

    inreplace 'configure', /config.h/, 'src/config.h'
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dlna",
                          "--with-libupnp-dir=#{HOMEBREW_PREFIX}",
                          "--with-libdlna-dir=#{HOMEBREW_PREFIX}",
                          "--disable-strip"
    system "make install"
    man1.install "src/ushare.1"
  end
end
