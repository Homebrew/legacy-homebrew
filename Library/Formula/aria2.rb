require "formula"

class Aria2 < Formula
  homepage "http://aria2.sourceforge.net/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.8/aria2-1.18.8.tar.bz2"
    sha1 "b6ad7064b1ea769e78f6a7dc9787a12cfc1e153f"

    # Upstream patch to fix crash on OSX when proxy is used
    # See: https://github.com/tatsuhiro-t/aria2/commit/9a931e7
    patch do
      url "https://github.com/tatsuhiro-t/aria2/commit/9a931e7.diff"
      sha1 "386c2a831e9ab91524a1af1eeb3037a819b85ec5"
    end
  end

  bottle do
    cellar :any
    sha1 "0bfe8bc96b7d95c0d45c9f84e725eb5eae64d1bf" => :yosemite
    sha1 "1c8c6558e0016c7e1ac2f01485a676b28df8ac55" => :mavericks
    sha1 "9199de445bcc3c9dd932781e96d1fa53dd7e922e" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  needs :cxx11

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

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
