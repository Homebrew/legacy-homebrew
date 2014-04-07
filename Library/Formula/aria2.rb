require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.5/aria2-1.18.5.tar.bz2'
  sha1 '91639bf99a2e84873675f470fd36cee47f466770'

  bottle do
    cellar :any
    sha1 "83ea8bf0f0356ad51491dee88c6b8c1747daf8e5" => :mavericks
    sha1 "cd2ce7a10e30a58c20554399bc7f9a115b1d7ca9" => :mountain_lion
    sha1 "650cceb7cdf00bfc807a331c79523f941f1cbaec" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on :macos => :lion # Needs a c++11 compiler

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    # system zlib and sqlite don't include .pc files
    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'
    ENV['SQLITE3_CFLAGS'] = '-I/usr/include'
    ENV['SQLITE3_LIBS'] = '-L/usr/lib -lsqlite3'

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
