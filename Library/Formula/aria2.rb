class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.9/aria2-1.18.9.tar.bz2"
  sha1 "31ac90d9ffcdba4cdf936ddfbc3d8f08416360e6"

  bottle do
    cellar :any
    sha1 "a82e7baf0bf64cd3beb6ee2c5d16c10534138852" => :yosemite
    sha1 "f0ab29fdeebb96b6f9594a7119b9210b820b28f4" => :mavericks
    sha1 "b931e5c286c97a5cc5d5ef2e21336dfc9fe62ea6" => :mountain_lion
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
