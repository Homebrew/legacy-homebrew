require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.42/libsoup-2.42.2.tar.xz'
  sha256 '1f4f9cc55ba483dc8defea0c3f97cc507dc48384c5529179e29c1e6d05630dbf'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib-networking' # Required at runtime for TLS support
  depends_on 'gnutls' # Also required for TLS
  depends_on 'sqlite' # For SoupCookieJarSqlite

  fails_with :clang do
      build 421
      cause <<-EOS.undent
      coding-test.c:69:28: error: format string is not a string literal [-Werror,-Wformat-nonliteral]
          file = g_strdup_printf (file_path, path);
                                  ^~~~~~~~~

      The same error was encountered here:
      http://clang.debian.net/logs/2012-06-23/libsoup2.4_2.38.1-2_unstable_clang.log
      EOS
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gnome",
                          "--disable-tls-check"
    system "make install"
  end
end
