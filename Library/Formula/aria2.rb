class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.19.0/aria2-1.19.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/aria2/aria2_1.19.0.orig.tar.bz2"
  sha256 "ae2b6fce7a0974c9156415cccf2395cd258580ab34eec2b34a8e76120b7240ce"

  bottle do
    cellar :any
    sha256 "74b5953f8370d15dae0c8461fe28152f356b71083d57f582ba93c2a29a9af2c0" => :yosemite
    sha256 "41d5c1c5c076451bced12bad349911f6db3ece6b5ca685a9915e0c7d460f8109" => :mavericks
    sha256 "e1a1d49a8dccd4e24371a685dd66d5d2a37e180c8fc2f733243cd68b77e3bf5b" => :mountain_lion
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
