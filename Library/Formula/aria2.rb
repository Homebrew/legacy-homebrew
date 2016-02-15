class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://github.com/tatsuhiro-t/aria2/releases/download/release-1.19.3/aria2-1.19.3.tar.xz"
  sha256 "6abcc6c28437a519cc1016736cb446ed38db360cb9828c4a7105526ea82299e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a7dc4f01466b7ebd1ac3d157e3c372bbb66a0f87c604eb85bd7ec1ccb060b56" => :el_capitan
    sha256 "27b50aad76dabf2903a65190dad5a2551b7634639464bf7d68fbb02967aab234" => :yosemite
    sha256 "212068e7572fd68f1fbc2e752d950d110a11fb61a64a1be8b43bd35c20b0c8a9" => :mavericks
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
