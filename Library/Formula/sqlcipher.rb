class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.3.1.tar.gz"
  sha256 "ce5167b2e4d7eb1514fd5a8dfc115a11c4b85f5fd88be2a9fd35ffbb684365bf"

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "fdcf3a84310a234b755cf5644fba43d1819f507e05505100f5d78602932bdda1" => :yosemite
    sha256 "c9a9268a27a0ff213d85ee902c9f0812dc5697d58f9236af24d1ba35ed618e4d" => :mavericks
    sha256 "13c911a0a72ddcf1b01529200b501441393006ae8324003dfe388f886084ee56" => :mountain_lion
  end

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS3"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
