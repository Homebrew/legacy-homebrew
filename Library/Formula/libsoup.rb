require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.38/libsoup-2.38.1.tar.xz'
  sha256 '71b8923fc7a5fef9abc5420f7f3d666fdb589f43a8c50892d584d58b3c513f9a'

  depends_on 'xz' => :build
  depends_on 'glib-networking'  # Required at runtime for TLS support
  depends_on 'gnutls'  # Also required for TLS
  depends_on 'sqlite'  # For SoupCookieJarSqlite

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
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-gnome"
    system "make install"
  end
end
