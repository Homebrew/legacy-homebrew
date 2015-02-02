class Aria2 < Formula
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.9/aria2-1.18.9.tar.bz2"
  sha1 "31ac90d9ffcdba4cdf936ddfbc3d8f08416360e6"

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

  test do
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist? "index.html"
  end
end
