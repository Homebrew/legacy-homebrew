require 'formula'

class Ushare < Formula
  homepage 'http://ushare.geexbox.org/'
  url 'http://ushare.geexbox.org/releases/ushare-1.1a.tar.bz2'
  md5 '5bbcdbf1ff85a9710fa3d4e82ccaa251'

  depends_on 'gettext'
  depends_on 'libupnp'
  depends_on 'libdlna'

  # Correct "OPTFLAGS" to "CFLAGS"
  def patches
    { :p0 =>
      "https://trac.macports.org/export/89267/trunk/dports/net/ushare/files/patch-configure.diff"
    }
  end

  def install
    # Need to explicitly add intl and gettext here.
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
