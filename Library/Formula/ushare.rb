require 'formula'

class Ushare < Formula
  homepage 'http://ushare.geexbox.org/'
  url 'http://ushare.geexbox.org/releases/ushare-1.1a.tar.bz2'
  sha1 '1539e83cde5d80f433d262d971f5fe78486c9375'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'libupnp'
  depends_on 'libdlna'

  # Correct "OPTFLAGS" to "CFLAGS"
  def patches
  { :p0 =>
    "https://trac.macports.org/export/89267/trunk/dports/net/ushare/files/patch-configure.diff"
  }
  end

  fails_with :clang do
    cause "clang removes inline functions, causing a link error:\n" +
          "\"_display_headers\", referenced from: _parse_command_line in cfgparser.o"
  end

  def install
    # Need to explicitly add intl and gettext here.
    gettext = Formula.factory("gettext")
    ENV.append 'CFLAGS', "-I#{gettext.include}"
    ENV.append 'LDFLAGS', "-lintl"

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
